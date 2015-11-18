class WebClient::ActionHandler
  attr_reader :nkey, :notifications

  def initialize(nkey)
    @nkey = nkey
    @notifications = Notification.find_notifications(nkey)
  end

  def do(action)
    notifications.each do |notification|
      notification.status = action.to_s
      Notification::Save.new(notification).do
    end
  end

  def valid?
    !notifications.empty?
  end
end
