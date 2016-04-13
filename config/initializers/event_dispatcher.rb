Zazo::Tools::EventDispatcher.configure do |config|
  config.send_message_enabled = false if Rails.env.test?
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

Zazo::Tools::EventDispatcher.send(:include, EventDispatcherWrapper)
=end
