Zazo::Tool::Logger.configure do |config|
  logstash_url = Figaro.env.logstash_url
  if logstash_url && !(Rails.env.test? || Rails.env.development?)
    config.logstash_enabled = true
    config.logstash_host = logstash_url.split(':').first
    config.logstash_port = logstash_url.split(':').last
    config.logstash_username = Figaro.env.logstash_username
    config.logstash_password = Figaro.env.logstash_password
  end
  config.project_name = AppConfig.app_name_key
end

Zazo::Tool::EventDispatcher.configure do |config|
  config.send_message_enabled = false if Rails.env.test? || Rails.env.development?
  config.queue_url = Figaro.env.sqs_queue_url
  config.logger = Rails.logger
end

#
# code below is just for testing
# tail -f log/development.log | grep EventDispatcher
#

=begin
module EventDispatcherWrapper
  def self.included(base)
    base.instance_eval do
      def emit(name, params = {})
        Rails.logger.info(['EventDispatcher', name, params])
      end
    end
  end
end

Zazo::Tool::EventDispatcher.send(:include, EventDispatcherWrapper)
=end
