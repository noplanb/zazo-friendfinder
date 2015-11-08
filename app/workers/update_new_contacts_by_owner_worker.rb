# resque worker

class UpdateNewContactsByOwnerWorker
  @queue = :update_contacts

  def self.perform(owner_mkey)
    WriteLog.info self, "resque job was executed at #{Time.now} for '#{owner_mkey}' owner"
    Contact::SetZazoIdAndMkeyByOwnerContacts.new(owner_mkey).do
    Score::CalculationByOwner.new(owner_mkey).do
  end
end
