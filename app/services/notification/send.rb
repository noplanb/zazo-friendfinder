class Notification::Send
  attr_reader :notifications

  def initialize(notifications)
    @notifications = notifications
  end

  def do
  end
end
