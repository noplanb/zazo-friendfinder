Zazo::Tools::Logger.configure do |config|
=begin
  logstash_url = Figaro.env.logstash_url
  if logstash_url && !(Rails.env.test? || Rails.env.development?)
    config.logstash_enabled = true
    config.logstash_host = logstash_url.split(':').first if logstash_url
    config.logstash_port = logstash_url.split(':').last.to_i if logstash_url
  end
=end
  config.project_name = AppConfig.app_name_key
end
