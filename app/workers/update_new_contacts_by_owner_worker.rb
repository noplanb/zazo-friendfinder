# resque worker

class UpdateNewContactsByOwnerWorker
  @queue = :update_contacts

  def self.perform(owner_mkey)
    WriteLog.info(self, "resque job was executed for owner_mkey=#{owner_mkey} ")
    Contact::SetZazoIdAndMkeyByOwnerContacts.new(owner_mkey).do
    Score::CalculationByOwner.new(owner_mkey).do
  end
end
