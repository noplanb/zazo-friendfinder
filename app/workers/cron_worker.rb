class CronWorker
  class << self
    DEFAULT_SETTINGS = {
      running_period: 10.years,
      default_last_running_date: Time.new('2010')
    }

    def worker_settings(settings)
      @settings = DEFAULT_SETTINGS.merge(settings)
    end

    def perform
      if last_running_date_expired?
        Zazo::Tools::Logger.info(self, 'expired')
        set_last_running_date(Time.now)
        yield if block_given?
      else
        Zazo::Tools::Logger.info(self, "not expired, will expire at #{get_expiration_date}")
      end
    end

    protected

    def settings
      @settings || DEFAULT_SETTINGS
    end

    def last_running_date_expired?
      get_expiration_date < Time.now
    end

    def get_expiration_date
      get_last_running_date + settings[:running_period]
    end

    def get_last_running_date
      Settings[name] || settings[:default_last_running_date]
    end

    def set_last_running_date(date)
      Settings[name] = date
    end
  end
end
