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
      WriteLog.info(self, "canceled; kind: '#{notification.kind}'; errors: #{data.errors.messages}; notification: #{notification.inspect}")
    end
  rescue Exception => e
    notification.update(state: 'error')
    exception = "(#{e.class}: #{e.response})"
    WriteLog.info(self, "exception; kind: '#{notification.kind}'; exception: #{exception}; notification: #{notification.inspect}")
  end

  private

  def handle_response(response, notification)
    if response['status'] == 'success'
      notification.update(state: 'sent')
      WriteLog.info(self, "sent; kind: '#{notification.kind}'; notification: #{notification.inspect}")
      true
    else
      notification.update(state: 'error')
      WriteLog.info(self, "error; kind: '#{notification.kind}'; errors: #{response['errors']}; notification: #{notification.inspect}", rollbar: :error)
      false
    end
  end
end
