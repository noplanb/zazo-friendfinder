class ResqueWorker::UpdateOwnerContactsOnly
  @queue = :update_contacts

  def self.perform(owner_mkey)
    Zazo::Tools::Logger.info(self, "started; owner: #{owner_mkey}")
    owner = Owner.new(owner_mkey)
    owner.contacts_actions.find_contact_and_update_info
  end
end
