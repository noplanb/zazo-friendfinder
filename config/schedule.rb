set :output, '/usr/src/app/log/cron.log'
set :environment, ENV['RAILS_ENV'] || 'production'

[:PATH, :GEM_HOME, :RACK_ENV, :RAILS_ENV, :SECRET_KEY_BASE,
 :AWS_ACCESS_KEY_ID, :AWS_REGION, :AWS_SECRET_ACCESS_KEY,
 :db_name, :db_host, :db_port, :db_username, :db_password,
 :dataprovider_api_base_url, :dataprovider_api_token,
 :notification_api_base_url, :notification_api_token,
 :sqs_queue_url, :logstash_url,
 :rollbar_access_token, :newrelic_license_key,
 :redis_host, :redis_port].each { |key| env(key, ENV[key.to_s]) }

#every(3.hours) { runner 'CronWorker::ScoresRecalculation.perform' }
every(10.minutes) { runner 'CronWorker::FakeUserJoinedNotification.perform' }
