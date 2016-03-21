class WebClient::AddContact
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    # TODO: add contact via sending api request to zazo-prod worker
    contact.update_attributes(additions: new_attributes)
  end

  def new_attributes
    (contact.additions || {}).merge('added_by_owner' => true)
  end
end
