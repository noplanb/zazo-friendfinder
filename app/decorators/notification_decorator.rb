class NotificationDecorator < Draper::Decorator
  delegate_all

  def kind
    template.try :kind
  end

  def has_template?
    !template.nil?
  end

  def data
    send "#{kind}_data"
  end

  def email_data
    Notification::EmailData.new(object).get
  end

  def mobile_data
    Notification::MobileData.new(object).get
  end
end
