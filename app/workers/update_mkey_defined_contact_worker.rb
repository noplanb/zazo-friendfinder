class UpdateMkeyDefinedContactWorker
  @queue = :update_contacts

  def self.perform(contact_id)
    contact = Contact.find contact_id
    Contact::UpdateZazoInfo.new(contact).do
    Score::CalculationByContact.new(contact).do
  end
end
