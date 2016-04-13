class Contact::BaseHandler
  attr_reader :contact, :caller

  def initialize(contact, caller: :web_client)
    @contact = contact
    @caller = caller
  end

  protected

  def emit_event(name)
    DispatchEvent.new(caller, name, [contact.owner, contact]).do
  end
end
