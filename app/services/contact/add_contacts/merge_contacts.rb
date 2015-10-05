class Contact::AddContacts::MergeContacts
  attr_reader :owner, :contact_data, :last_coincidence

  def initialize(owner, contact_data)
    @owner = owner
    @contact_data = contact_data
  end

  def do
    return false unless last_coincidence || necessary_to?
    contact_data['vectors'].select do |vector_data|
      Contact.by_owner(owner).each do |contact|
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
    Contact.by_owner(owner).each do |contact|
      return contact if match_by_mobile_vector?(contact) || total_vectors_matches(contact) > 1
    end && nil
  end

  def match_by_mobile_vector?(contact)
    existing_vector = contact.vectors.mobile.first
    existing_vector && contact_data['vectors'].select do |vector_data|
      vector_data['name'] == 'mobile' && vector_data['value'] == existing_vector.value
    end.size > 0
  end

  def total_vectors_matches(contact)
    contact_data['vectors'].select do |vector_data|
      vector_already_exist? contact, vector_data
    end.size
  end

  def vector_already_exist?(contact, vector_data)
    contact.vectors.select { |vector| vector.name == vector_data['name'] && vector.value == vector_data['value'] }.size > 0
  end
end
