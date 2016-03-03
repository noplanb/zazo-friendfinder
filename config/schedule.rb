set :output, '/usr/src/app/log/cron.log'

[
  :PATH, :GEM_HOME, :RACK_ENV, :RAILS_ENV, :secret_key_base,
  :db_name, :db_host, :db_port, :db_username, :db_password,
  :dataprovider_api_base_url, :dataprovider_api_token,
  :rollbar_access_token, :newrelic_license_key,
  :redis_host, :redis_port,
].each { |key| env key, ENV[key.to_s] }

every(3.hours) { runner 'ScoresRecalculationWorker.perform' }
#every(1.day)   { runner 'Notification::UserJoinedWorker.perform' }
#every(2.days)  { runner 'Notification::FakeUserJoinedWorker.perform' }
