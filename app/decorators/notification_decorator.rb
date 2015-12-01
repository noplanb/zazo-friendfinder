class NotificationDecorator < Draper::Decorator
  delegate_all

  def data
    @data ||= send "#{kind}_data"
  end

  def send_notification
    Notification::Send.new(object).do
  end

  def email_data
    Notification::EmailData.new object
  end

  def mobile_data
    Notification::MobileData.new object
  end

  def inspect
    object.inspect
  end
end
