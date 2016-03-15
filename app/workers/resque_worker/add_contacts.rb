class ResqueWorker::AddContacts
  @queue = :add_contacts

  def self.perform(owner_mkey, contacts_data)
    Contact::AddContacts.new(owner_mkey, contacts_data).do
    Resque.enqueue(ResqueWorker::UpdateNewContactsByOwner, owner_mkey)
  end
end
