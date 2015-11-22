class Notification::EmailData < Notification::BaseData
  attr_reader :email, :content, :subject
  validates   :email, :content, :subject, presence: true

  def get
    { to: email,
      subject: subject,
      body: content }
  end

  private

  def set_attributes
    @email   = fetch_emails.first
    @content = object.compiled_content
    @subject = "#{object.contact.display_name} joined Zazo!"
  end

  def fetch_emails
    StatisticsApi.new(user: object.contact.owner_mkey, attrs: [:emails]).attributes['emails']
  end
end
