module Notification::SendingExtension
  def send_notification
    Notification::Send.new(self).do
  end

  def data
    @data ||= send("#{kind}_data")
  end

  def email_data
    Notification::EmailData.new(self)
  end

  def mobile_data
    Notification::MobileData.new(self)
  end
end
