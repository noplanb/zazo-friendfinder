class Notification::EmailData < Notification::Data
  attr_reader :email, :content
  validates   :email, :content, presence: true

  def get
    { to: email,
      subject: '',
      body: content }
  end

  private

  def set_attributes
    @email = fetch_emails.first
    @content = object.compiled_content
  end

  def fetch_emails
    StatisticsApi.new(user: object.contact.owner_mkey, attrs: [:emails]).attributes['emails']
  end
end
