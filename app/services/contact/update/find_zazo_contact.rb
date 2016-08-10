class Contact::Update::FindZazoContact
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    data = user_data
    update_contact(data) if data
    contact
  end

  private

  def update_contact(data)
    contact.zazo_id = data['id'].to_i
    contact.zazo_mkey = data['mkey']
    contact.save
  end

  def user_data
    phones = contact.vectors.mobile.map(&:value)
    data = DataProviderApi.new(
      phones: phones, friend: contact.owner.mkey).query(:find_by_mobile)
    data['id'] && data['mkey'] ? data : nil
  rescue Faraday::ClientError
    nil
  end
end
