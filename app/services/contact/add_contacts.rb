class Contact::AddContacts
  attr_reader :current_user, :raw_params, :errors

  def initialize(current_user, params)
    @current_user = current_user
    @raw_params   = params || []
    @errors = {}
  end

  def do
    wrap_transaction do
      raw_params.each do |contact_data|
        instance = Contact.create new_contact_attrs(contact_data)
        add_errors(:contacts, instance.errors.messages) unless instance.valid?
        add_vectors_to_contact instance, contact_data['vectors']
      end
      raise ActiveRecord::Rollback unless errors.empty?
    end
  end

  private

  def wrap_transaction
    ActiveRecord::Base.transaction { yield; return true }
    false
  end

  def add_vectors_to_contact(contact, vectors)
    vectors.each do |vector_data|
      instance = Vector.create new_vector_params(vector_data, contact)
      add_errors(:vectors, instance.errors.messages) unless instance.valid?
    end
  end

  def add_errors(prefix, errors)
    @errors[prefix] ||= []
    @errors[prefix] << errors
  end

  def new_contact_attrs(contact_data)
    { owner: current_user.mkey,
      first_name: contact_data['first_name'],
      last_name: contact_data['last_name'] }
  end

  def new_vector_params(vector_data, contact)
    { contact: contact,
      name: vector_data['name'],
      value: vector_data['value'],
      additions: vector_data['additions'] }
  end
end
