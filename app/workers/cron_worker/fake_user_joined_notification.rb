class CronWorker::FakeUserJoinedNotification
  class << self
    def perform
      if Settings.fake_notifications_enabled
        Zazo::Tools::Logger.info(self, 'started')
        owners = get_owners
        owners.each { |owner| send_fake_notifications(owner) }
        Zazo::Tools::Logger.info(self, "completed; owners: #{owners.map(&:mkey).to_json}")
      else
        Zazo::Tools::Logger.info(self, 'disabled')
      end
    end

    private

    def send_fake_notifications(owner)
      contact = owner.contacts.suggestible.first
      Notification::Create.new(:fake_user_joined,
        contact, notification_options).do.each do |n|
        n.send_notification
      end if contact
    end

    def get_owners
      return Owner.subscribed unless Settings.notify_specific_owners_only
      (Settings.specific_owners || []).map { |mkey| Owner.new(mkey) }
    end

    def notification_options
      { mobile: Settings.mobile_notifications_enabled,
        email:  Settings.email_notifications_enabled }
    end
  end
end
