class Contact::SetZazoIdAndMkey
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
    contact.zazo_id   = data['id'].to_i
    contact.zazo_mkey = data['mkey']
    contact.save
  end

  def user_data
    (contact.vectors.mobile + contact.vectors.email).each do |vector|
      data = data_by_vector vector
      return data if data['id'] && data['mkey']
    end && nil
  end

  def data_by_vector(vector)
    StatisticsApi.new(vector.name => vector.value).users :find_by_mobile_or_email
  end
end
