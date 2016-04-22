class Contact::Invite
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    contact.owner.fetch_data
    api = MainServerApi.new(attributes)
    api.digest_auth(contact.owner.mkey, contact.owner.auth)
    update_contact(api.invite)
    Zazo::Tools::Logger.info(self, "success; contact: #{contact.to_json}")
  rescue Faraday::ClientError => e
    Zazo::Tools::Logger.info(self, "failure; error: #{e.message}; response: #{e.response[:body]}; contact: #{contact.to_json}")
  end

  private

  def update_contact(data)
    contact.update_attributes(
      zazo_id:    data['id'],
      zazo_mkey:  data['mkey'],
      first_name: data['first_name'],
      last_name:  data['last_name'])
  end

  #
  # contact attributes
  #

  def attributes
    first_name, last_name = first_last_name
    { first_name: first_name, last_name: last_name, mobile_number: mobile_number, emails: emails }
  end

  def first_last_name
    full_name = contact.display_name.gsub(/[(){}!@#$%^&*]+/, ' ').split(' ')
    return contact.first_name || full_name[0], contact.last_name || full_name[1..-1].join(' ')
  end

  def mobile_number
    contact.vectors.mobile.pluck(:value).first
  end

  def emails
    contact.vectors.email.pluck(:value)
  end
end
