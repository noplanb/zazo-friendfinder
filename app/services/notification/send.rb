class Notification::Send
  attr_reader :notification

  def initialize(notification)
    @notification = notification
  end

  def do
    data = notification.data
    if data.valid?
      handle_response(NotificationApi.new(data.get).send(notification.kind), notification)
    else
      notification.update(state: 'canceled')
      WriteLog.info(self, "was canceled as '#{notification.kind}' because data is not valid, data errors: #{data.errors.messages}, #{notification.inspect}")
    end
  rescue Exception => exception
    notification.update(state: 'error')
    inspected_exception = "(#{exception.class}: #{exception.message})"
    WriteLog.info(self, "exception fired while sending as '#{notification.kind}': #{inspected_exception}, #{notification.inspect}")
    raise exception
  end

  private

  def handle_response(response, notification)
    if response['status'] == 'success'
      notification.update(state: 'sent')
      WriteLog.info(self, "was sent as '#{notification.kind}', #{notification.inspect}")
      true
    else
      notification.update(state: 'error')
      WriteLog.info(self, "errors occurred while sending as '#{notification.kind}', errors: #{response['errors']}, #{notification.inspect}", rollbar: :error)
      false
    end
  end
end
