class WebClient::TrackEmail
  attr_reader :notification

  def initialize(params)
    @notification = Notification.by_nkey(params[:id]).first
  end

  def do
    return unless notification
    DispatchEvent.new(:notification, %w(email opened), [notification, notification.contact.owner]).do
    Zazo::Tools::Logger.info(self, "tracked; owner: #{notification.contact.owner.mkey}")
  end
end
