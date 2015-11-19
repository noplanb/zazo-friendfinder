class Contact::GetZazoFriends
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    StatisticsApi.new(user_mkey: contact.owner.mkey).users :get_zazo_friends
  end
end
