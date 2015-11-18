class Notification::Save
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def do
    unless notification.save
      WriteLog.info self, "notification was not saved with errors: #{notification.errors.messages}, inspected: #{notification.inspect}", rollbar: :error
      return false
    end; true
  end
end
