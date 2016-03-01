class WriteLog
  def self.info(context, message, settings = {})
    tag = get_class_name context
    logging_local   :info, tag, message
    #logging_syslog  :info, tag, message
    logging_rollbar settings[:rollbar], tag, message if settings[:rollbar]
  end

  def self.debug(context, message)
    tag = "#{get_class_name context} [DEBUG]"
    logging_local  :debug, tag, message
    #logging_syslog :debug, tag, message
  end

  private

  def self.logging_local(log_level, tag, message)
    Rails.logger.tagged(tag) { Rails.logger.send log_level, message } if Rails.logger.respond_to? log_level
  end

  def self.logging_syslog(log_level, tag, message)
    Rails.syslogger.send log_level, "[#{tag}] #{message}" if %w(production staging).include?(Rails.env) && Rails.syslogger.respond_to?(log_level)
  end

  def self.logging_rollbar(log_level, tag, message)
    Rollbar.send log_level, "[#{tag}] #{message}" if Rollbar.respond_to? log_level
  end

  def self.get_class_name(context)
    context.instance_of?(Class) ? context.name : context.class.name
  end
end
