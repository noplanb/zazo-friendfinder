# Using papertrailapp.com for app logs management

def Rails.syslogger
  RemoteSyslogLogger.new(
    ENV['papertrail_host'], ENV['papertrail_port'],
    program: APP_INFO['app_key'], local_hostname: APP_INFO['app_env']
  )
end
