class Contact::FindOwnersByContactMatching
  attr_reader :contact_data

  def initialize(contact_data)
    @contact_data = contact_data
  end

  def do
    Contact.joins(:vectors).where(vectors: { name: 'mobile', value: contact_data['mobile_number'] }).to_a
  end
end
