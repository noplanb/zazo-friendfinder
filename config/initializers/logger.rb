Zazo::Tools::Logger.configure do |config|
  config.logstash_enabled = true unless Rails.env.test?

  config.logstash_host = Figaro.env.logstash_url.split(':').first
  config.logstash_port = Figaro.env.logstash_url.split(':').last.to_i

  config.project_name = AppConfig.app_name_key
end
