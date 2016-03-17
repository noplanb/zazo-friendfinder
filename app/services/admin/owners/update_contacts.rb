class Admin::Owners::UpdateContacts < Admin::Owners
  def do
    if owner.contacts.count > 0
      Resque.enqueue(ResqueWorker::UpdateOwnerContactsOnly, owner.mkey)
      [true, "Updating contacts for owner (#{@owner.mkey}) was started"]
    else
      [false, 'No contacts to update']
    end
  end
end
