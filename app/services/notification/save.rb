class Notification::Save
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def do
    if notification.save
      true
    else
      WriteLog.info(self, "error; errors: #{notification.errors.messages}; notification: #{notification.inspect}", rollbar: :error)
      false
    end
  end
end
