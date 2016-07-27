class Contact::Import::ImportContacts
  attr_reader :owner, :raw_params, :errors

  def initialize(owner_mkey, raw_params)
    @owner = Owner.new(owner_mkey)
    @raw_params = raw_params
    @errors = {}
  end

  def do
    drop_unmarked_contacts
    raw_params.each { |contact_data| add_or_merge_contact(contact_data) }

    status = errors.empty?
    Zazo::Tool::Logger.info(self, "errors (added); owner: #{owner.mkey}; errors: #{errors.inspect}") unless status
    status
  end

  private

  #
  # business logic
  #

  def drop_unmarked_contacts
    owner.contacts.not_added.not_ignored.not_proposed.not_recommended.destroy_all
  end

  def add_or_merge_contact(contact_data)
    merge_contacts = Contact::Import::MergeContacts.new(owner.mkey, contact_data)
    if merge_contacts.necessary_to?
      merge_contacts.do { |contact, vector_data| add_vector_to_contact(contact, vector_data) }
    else
      instance = Contact.create(new_contact_attrs(contact_data))
      add_errors(:contacts, instance.errors.messages) unless instance.valid?
      add_vectors_to_contact(instance, contact_data['vectors'])
    end
  end

  def add_vectors_to_contact(contact, vectors_data)
    vectors_data.each do |vector_data|
      add_vector_to_contact(contact, vector_data)
    end if vectors_data
  end

  def add_vector_to_contact(contact, vector_data)
    instance = Vector.create(new_vector_params(vector_data, contact))
    add_errors(:vectors, instance.errors.messages) unless instance.valid?
  end

  #
  # complex attributes
  #

  def new_contact_attrs(contact_data)
    { owner_mkey: owner.mkey,
      display_name: contact_data['display_name'],
      additions: contact_data['additions'] }
  end

  def new_vector_params(vector_data, contact)
    { contact: contact,
      name: vector_data['name'],
      value: vector_data['value'],
      additions: vector_data['additions'] }
  end

  #
  # helpers
  #

  def add_errors(prefix, errors)
    @errors[prefix] ||= []
    @errors[prefix] << errors
  end
end
