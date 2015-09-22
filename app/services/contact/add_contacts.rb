class Contact::AddContacts
  attr_reader :current_user, :raw_params, :errors

  def initialize(current_user, params)
    @current_user = current_user
    @raw_params   = params || []
    @errors = {}
  end

  def do
    if contacts_persisted?
      add_errors(:contacts, 'contacts by this user already persisted')
      return false
    end
    raw_params.each do |contact_data|
      instance = Contact.create new_contact_attrs(contact_data)
      add_errors(:contacts, instance.errors.messages) unless instance.valid?
      add_vectors_to_contact instance, contact_data['vectors']
    end
    errors.empty?
  end

  def log_messages(status)
    if status == :success
      WriteLog.info self, "contacts was added successfully at #{Time.now} for '#{current_user.mkey}' owner"
    else
      WriteLog.info self, "contacts was added at #{Time.now} for '#{current_user.mkey}' owner with errors: #{errors.inspect}"
    end
  end

  private

  def add_vectors_to_contact(contact, vectors)
    vectors && vectors.each do |vector_data|
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
      display_name: contact_data['display_name'],
      additions: contact_data['additions'] }
  end

  def new_vector_params(vector_data, contact)
    { contact: contact,
      name: vector_data['name'],
      value: vector_data['value'],
      additions: vector_data['additions'] }
  end

  def contacts_persisted?
    Contact.by_owner(current_user.mkey).select { |c| !c.additions_value('recommended_by') }.size != 0
  end
end
