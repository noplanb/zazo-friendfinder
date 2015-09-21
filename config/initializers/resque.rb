Resque.redis = Redis.new(host: ENV['redis_host'], port: ENV['redis_port'], thread_safe: true)
