class Notification::MobileData < Notification::BaseData
  attr_reader :push_token, :device_platform, :subject, :content, :payload, :device_build, :response
  validates :push_token, :device_platform, :subject, :payload, presence: true
  validate :validate_response

  def get
    { subject: subject,
      device_platform: device_platform,
      device_build: device_build,
      device_token: push_token,
      payload: payload }
  end

  private

  def set_attributes
    push_user = fetch_push_user
    @push_token      = push_user['push_token']
    @device_platform = push_user['device_platform']
    @device_build    = push_user['device_build']
    @subject = "#{object.contact.display_name} joined Zazo!"
    @content = object.compiled_content
    @payload = {
      type: 'friend_joined',
      content: content,
      subject: subject,
      nkey: object.nkey,
      additions: {
        friend_name: object.contact.display_name,
        phone_numbers: object.contact.phone_numbers,
        owner_mkey: object.contact.owner.mkey
      }
    }.merge(payload_host)
  end

  def payload_host
    case Rails.env
      when 'production' then { host: 'prod.zazoapp.com' }
      when 'staging' then { host: 'staging.zazoapp.com' }
      else {}
    end
  end

  def fetch_push_user
    @response = DataProviderApi.new(user_mkey: object.contact.owner_mkey).query(:push_user)
  rescue Faraday::ClientError => e
    @response = JSON.parse(e.response[:body])
  end

  def validate_response
    errors.add(:response, response['errors']) if response['errors']
  end
end
