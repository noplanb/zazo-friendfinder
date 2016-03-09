class Contact::GetZazoFriends
  attr_reader :owner_mkey

  def initialize(owner_mkey)
    @owner_mkey = owner_mkey
  end

  def do
    params = { user: owner_mkey, attrs: :friends }
    DataProviderApi.new(params).query(:attributes)['friends'] rescue []
  end
end
