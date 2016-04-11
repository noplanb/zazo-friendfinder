class Contact::BaseHandler
  attr_reader :contact, :caller

  def initialize(contact, caller: :web_client)
    @contact = contact
    @caller = caller
  end

  protected

  def emit_event(name)
    Zazo::Tools::EventDispatcher.emit(name, build_event)
  end

  def build_event
    { triggered_by: "ff:#{caller}",
      initiator: 'owner',
      initiator_id: contact.owner.mkey,
      target: 'contact',
      target_id: contact.id }
  end
end
