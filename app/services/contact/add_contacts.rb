class Contact::AddContacts
  attr_reader :current_user, :raw_params

  def initialize(current_user, params)
    @current_user = current_user
    @raw_params   = params
  end

  def do
    raw_params.each do |contact|
      instance = Contact.create first_name: contact['first_name'], last_name: contact['last_name']
      add_vectors_to_contact instance, contact['vectors']
    end
  end

  private

  def add_vectors_to_contact(contact, vectors)
    vectors.each do |vector|

    end
  end
end
