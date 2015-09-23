Resque.redis = Redis.new(host: ENV['redis_host'], port: ENV['redis_port'], thread_safe: true)

ENV['RESQUE_WEB_HTTP_BASIC_AUTH_USER'] = Figaro.env.http_basic_name
ENV['RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD'] = Figaro.env.http_basic_password
