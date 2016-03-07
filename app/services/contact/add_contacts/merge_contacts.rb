class Contact::AddContacts::MergeContacts
  attr_reader :owner, :contact_data, :last_coincidence

  def initialize(owner, contact_data)
    @owner = Owner.new(owner)
    @contact_data = contact_data
  end

  def do
    return false unless last_coincidence || necessary_to?
    contact_data['vectors'].select do |vector_data|
      owner.contacts.each do |contact|
        yield contact, vector_data if block_given? && !vector_already_exist?(contact, vector_data)
      end
    end
  end

  def necessary_to?
    @last_coincidence = find_by_coincidence
    !last_coincidence.nil?
  end

  private

  def find_by_coincidence
    return if !contact_data['vectors'] || contact_data['vectors'].empty?
    matches_by_vectors = contact_data['vectors'].each_with_object({}) do |vector_data, matches|
      contacts = owner.contacts.includes(:vectors)
      conditions = { vectors: { name: vector_data['name'], value: vector_data['value'] } }
      matches[vector_data['name']] ||= []
      matches[vector_data['name']] += contacts.where(conditions).to_a
    end
    contact_by_mobile_vector(matches_by_vectors) || contact_by_total_vectors(matches_by_vectors)
  end

  def contact_by_mobile_vector(matches)
    matches['mobile'] && (matches['mobile'].empty? ? nil : matches['mobile'].first)
  end

  def contact_by_total_vectors(matches)
    matches.except('mobile').each_with_object({}) do |(_, contacts), matches_by_contact|
      contacts.each do |contact|
        matches_by_contact[contact] ||= 0
        matches_by_contact[contact] += 1
      end
    end.select { |_, count| count > 1 }.sort_by { |_, count| count }.reverse.try(:first).try(:first)
  end

  def vector_already_exist?(contact, vector_data)
    contact.vectors.select { |vector| vector.name == vector_data['name'] && vector.value == vector_data['value'] }.size > 0
  end
end
