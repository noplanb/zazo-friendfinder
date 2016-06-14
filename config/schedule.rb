ENV_VARIABLES = [
  :PATH, :GEM_HOME, :RACK_ENV, :RAILS_ENV, :SECRET_KEY_BASE,
  :AWS_ACCESS_KEY_ID, :AWS_REGION, :AWS_SECRET_ACCESS_KEY,
  :db_name, :db_host, :db_port, :db_username, :db_password,
  :dataprovider_api_base_url, :dataprovider_api_token,
  :notification_api_base_url, :notification_api_token,
  :friendfinder_base_url, :sqs_queue_url,
  :logstash_url, :logstash_username, :logstash_password,
  :rollbar_access_token, :newrelic_license_key,
  :redis_host, :redis_port
]

settings = case ENV['RAILS_ENV']
  when 'development'
    { output: 'log/cron.log', environment: 'development', env: false, period: 1.minute }
  when 'staging'
    { output: '/usr/src/app/log/cron.log', environment: 'staging', env: true, period: 5.minutes }
  else
    { output: '/usr/src/app/log/cron.log', environment: 'production', env: true, period: 1.hour }
end

set :output, settings[:output]
set :environment, settings[:environment]

ENV_VARIABLES.each { |key| env(key, ENV[key.to_s]) } if settings[:env]

every(settings[:period]) { runner 'CronWorker::FakeUserJoinedNotification.perform' }
