# TODO: write some specs

class Contact::Invite < Contact::BaseHandler
  attr_accessor :phone_number

  def do
    contact.owner.fetch_data
    api = MainServerApi.new(attributes)
    api.digest_auth(contact.owner.mkey, contact.owner.auth)
    handle_response(api.invite)
  rescue Faraday::ClientError => e
    Zazo::Tools::Logger.info(self, "failure; error: #{e.message}; response: #{e.response[:body]}; contact: #{contact.to_json}")
    nil
  end

  private

  def handle_response(response)
    if response['status'] == 'failure'
      Zazo::Tools::Logger.info(self, "failure; response: #{response.to_json}; contact: #{contact.to_json}")
      nil
    else
      update_contact(response)
      emit_event(%w(contact invited))
      Zazo::Tools::Logger.info(self, "success; response: #{response.to_json}; contact: #{contact.to_json}")
      response
    end
  end

  def update_contact(data)
    contact.update_attributes(
      zazo_id:    data['id'],
      zazo_mkey:  data['mkey'],
      first_name: data['first_name'],
      last_name:  data['last_name'])
    contact.update_attributes(additions: new_additions)
  end

  def new_additions
    (contact.additions || {}).merge('marked_as_friend' => true)
  end

  #
  # contact attributes
  #

  def attributes
    first_name, last_name = contact_first_last_name
    { first_name: first_name, last_name: last_name, mobile_number: contact_phone_number, emails: contact_emails }
  end

  def contact_first_last_name
    full_name = contact.display_name.gsub(/[(){}!@#$%^&*]+/, ' ').split(' ')
    return contact.first_name || full_name[0], contact.last_name || full_name[1..-1].join(' ')
  end

  def contact_phone_number
    phone_numbers = contact.vectors.mobile.pluck(:value)
    phone_numbers.include?(phone_number) ? phone_number : phone_numbers.first
  end

  def contact_emails
    contact.vectors.email.pluck(:value)
  end
end
