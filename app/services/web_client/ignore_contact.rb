class WebClient::IgnoreContact
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    contact.update_attributes(additions: new_attributes)
  end

  private

  def new_attributes
    (contact.additions || {}).merge('rejected_by_owner' => true)
  end
end
