class UpdateNewContactsByOwnerWorker
  @queue = :update_contacts

  def self.perform(owner_mkey)
    Contact::SetZazoIdAndMkeyByOwnerContacts.new(owner_mkey).do
    Score::CalculationByOwner.new(owner_mkey).do
  end
end
