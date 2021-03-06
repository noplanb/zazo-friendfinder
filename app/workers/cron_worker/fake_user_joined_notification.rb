class CronWorker::FakeUserJoinedNotification < CronWorker
  worker_settings case Rails.env
    when 'development' then { running_period: 2.minutes }
    when 'staging' then { running_period: 8.minutes }
    else { running_period: 4.days }
  end

  class << self
    def perform(force: false)
      block = -> {
        if Settings.fake_notifications_enabled
          Zazo::Tool::Logger.info(self, 'started')
          owners = get_owners
          owners.each { |owner| send_fake_notifications(owner) }
          Zazo::Tool::Logger.info(self, "completed for #{owners.size} owner(s); owners: #{owners.map(&:mkey).to_json}")
        else
          Zazo::Tool::Logger.info(self, 'disabled')
        end
      }
      force ? block.call : super(&block)
    end

    private

    def send_fake_notifications(owner)
      contact = get_suggestible_contact(owner)
      Notification::Create.new(:fake_user_joined,
        contact, notification_options).do.each do |n|
        n.send_notification
      end if contact
    end

    def get_owners
      return Owner.subscribed unless Settings.notify_specific_owners_only
      (Settings.specific_owners || []).map { |mkey| Owner.new(mkey) }
    end

    def get_suggestible_contact(owner)
      Owner::GetSuggestibleContact.new(owner).call
    end

    def notification_options
      { mobile: Settings.mobile_notifications_enabled,
        email:  Settings.email_notifications_enabled }
    end
  end
end
