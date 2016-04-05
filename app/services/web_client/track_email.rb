class WebClient::TrackEmail
  attr_reader :notification

  def initialize(params)
    @notification = Notification.by_nkey(params[:id]).first
  end

  def do
    return unless notification
    WriteLog.info(self, "tracked; owner: #{notification.contact.owner.mkey}")
  end
end
