class Notification::EmailData < Notification::BaseData
  attr_reader :email, :content, :subject, :response
  validates   :email, :content, :subject, presence: true
  validate    :validate_response

  def get
    { to: email,
      subject: subject,
      body: content,
      from: AppConfig.email_notification_from }
  end

  private

  def set_attributes
    @email   = fetch_emails.first
    @content = object.compiled_content
    @subject = "#{object.contact.display_name} joined Zazo!"
  end

  def fetch_emails
    @response = StatisticsApi.new(user: object.contact.owner_mkey, attrs: [:emails]).attributes
    response['emails']
  rescue Faraday::ClientError => e
    @response = JSON.parse e.response[:body]
    []
  end

  def validate_response
    errors.add :response, JSON.parse(response['errors']) if response['errors']
  end
end
