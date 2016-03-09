class Contact::GetZazoFriends
  attr_reader :contact

  def initialize(contact)
    # todo: refactor this to get owner mkey not contact
    @contact = contact
  end

  def do
    params = { user: contact.owner.mkey, attrs: :friends }
    DataProviderApi.new(params).query(:attributes)['friends'] rescue []
  end
end
