class ResqueWorker::UpdateMkeyDefinedContact
  @queue = :update_contacts

  def self.perform(contact_id)
    Zazo::Tools::Logger.info(self, "started; contact_id: #{contact_id}")
    contact = Contact.find(contact_id)
    Contact::UpdateZazoInfo.new(contact).do
    Score::CalculationByContact.new(contact).do
  end
end
