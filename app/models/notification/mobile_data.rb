class Notification::MobileData < Notification::BaseData
  attr_reader :push_token, :device_platform, :subject, :content, :payload, :device_build, :response
  validates   :push_token, :device_platform, :subject, :content, :payload, presence: true
  validate    :validate_response

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
        friend_name: object.contact.display_name
      }
    }
  end

  def fetch_push_user
    @response = StatisticsApi.new(mkey: object.contact.owner_mkey).push_user
  rescue Faraday::ClientError => e
    @response = JSON.parse e.response[:body]
  end

  def validate_response
    errors.add :response, JSON.parse(response['errors']) if response['errors']
  end
end
