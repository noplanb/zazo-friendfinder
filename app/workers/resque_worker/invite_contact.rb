class ResqueWorker::InviteContact
  @queue = :update_contacts

  def self.perform(contact_id, caller)
    Zazo::Tool::Logger.info(self, "started; contact_id: #{contact_id}")
    contact = Contact.find(contact_id)
    Contact::Invite.new(contact, caller: caller).do
  end
end
