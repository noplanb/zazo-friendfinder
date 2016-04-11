class WebClient::TrackEmail
  attr_reader :notification

  def initialize(params)
    @notification = Notification.by_nkey(params[:id]).first
  end

  def do
    return unless notification
    Zazo::Tools::EventDispatcher.emit(%w(email opened),
      triggered_by: 'ff:notification',
      initiator: 'notification',
      initiator_id: notification.nkey,
      target: 'owner',
      target_id: notification.contact.owner.mkey)
    WriteLog.info(self, "tracked; owner: #{notification.contact.owner.mkey}")
  end
end
