class ResqueWorker::UpdateMkeyDefinedContact
  @queue = :update_contacts

  def self.perform(contact_id)
    WriteLog.info(self, "resque job was executed for contact_id=#{contact_id}")
    contact = Contact.find(contact_id)
    Contact::UpdateZazoInfo.new(contact).do
    Score::CalculationByContact.new(contact).do
  end
end
