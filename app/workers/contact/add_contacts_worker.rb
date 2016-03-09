# resque worker

class Contact::AddContactsWorker
  @queue = :add_contacts

  def self.perform(current_user_mkey, contacts_data)
    Contact::AddContacts.new(current_user_mkey, contacts_data).do
    Resque.enqueue(UpdateNewContactsByOwnerWorker, current_user_mkey)
  end
end
