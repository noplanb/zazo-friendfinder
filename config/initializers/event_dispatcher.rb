Zazo::Tools::EventDispatcher.configure do |config|
  config.send_message_enabled = false if Rails.env.development? || Rails.env.test?
  config.queue_url = Figaro.env.sqs_queue_url
  config.logger = Rails.logger
end
