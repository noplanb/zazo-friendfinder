class ResqueWorker::UpdateNewContactsByOwner
  @queue = :update_contacts

  def self.perform(owner_mkey)
    WriteLog.info(self, "resque job was executed for owner_mkey=#{owner_mkey}")
    owner = Owner.new(owner_mkey)
    owner.contacts_actions.find_contact_and_update_info
    owner.contacts_actions.recalculate_scores
  end
end
