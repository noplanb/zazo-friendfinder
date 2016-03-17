class Notification::Save
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def do
    if notification.save
      true
    else
      WriteLog.info(self, "notification was not saved with errors: #{notification.errors.messages}, inspected: #{notification.inspect}", rollbar: :error)
      false
    end
  end
end
