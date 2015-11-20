class Notification::Send
  attr_reader :notifications

  def initialize(notifications)
    @notifications = NotificationDecorator.decorate_collection notifications
  end

  def do
    notifications.each do |notification|
      send "send_#{notification.kind}", notification if notification.has_template?
    end
  end

  private

  def send_email(notification)
    params = { to: '',
               subject: '',
               body: notification.compiled_content }
    handle_response NotificationApi.new(params).email, notification
  end

  def send_mobile_notification(notification)
    params = { subject: '',
               body: notification.compiled_content }
    handle_response NotificationApi.new(params).mobile, notification
  end

  def handle_response(response, notification)
    if response['status'] == 'success'
      notification.update state: 'sent'
      WriteLog.info self, "was sent as '#{notification.kind}' at #{Time.now}, #{notification.inspect}."
      true
    else
      notification.update state: 'error'
      WriteLog.info self, "errors occurred while sending as '#{notification.kind}' at #{Time.now}, errors: #{response['errors']}, #{notification.inspect}."
      false
    end
  end
end
