class Contact::AddContacts
  attr_reader :current_user_mkey, :raw_params, :errors

  def initialize(current_user_mkey, raw_params)
    @current_user_mkey = current_user_mkey
    @raw_params = raw_params
    @errors = {}
  end

  def do
    DropBeforeUpdate.new(current_user_mkey).do
    raw_params.each { |contact_data| add_or_merge_contact(contact_data) }
    errors.empty? # todo: log errors
  end

  private

  #
  # business logic
  #

  def add_or_merge_contact(contact_data)
    merge_contacts = MergeContacts.new(current_user_mkey, contact_data)
    if merge_contacts.necessary_to?
      merge_contacts.do { |contact, vector_data| add_vector_to_contact(contact, vector_data) }
    else
      instance = Contact.create(new_contact_attrs(contact_data))
      add_errors(:contacts, instance.errors.messages) unless instance.valid?
      add_vectors_to_contact(instance, contact_data['vectors'])
    end
  end

  def add_vectors_to_contact(contact, vectors_data)
    vectors_data && vectors_data.each { |vector_data| add_vector_to_contact(contact, vector_data) }
  end

  def add_vector_to_contact(contact, vector_data)
    instance = Vector.create(new_vector_params(vector_data, contact))
    add_errors(:vectors, instance.errors.messages) unless instance.valid?
  end

  #
  # complex attributes
  #

  def new_contact_attrs(contact_data)
    { owner_mkey: current_user_mkey,
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
