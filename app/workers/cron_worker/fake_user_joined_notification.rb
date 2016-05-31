class CronWorker::FakeUserJoinedNotification
  class << self
    def perform
      if Settings.fake_notifications_enabled
        Zazo::Tools::Logger.info(self, 'started')
        send_fake_notifications
      else
        Zazo::Tools::Logger.info(self, 'disabled')
      end
    end

    private

    def send_fake_notifications
      owners.each do |owner|
        contact = owner.contacts.suggestible.first
        Notification::Create.new(:fake_user_joined, contact).do.each do|n|
          n.send_notification
        end if contact
      end
    end

    def owners
      return Owner.subscribed unless Settings.notify_specific_owners_only
      (Settings.specific_owners || []).map { |mkey| Owner.new(mkey) }
    end
  end
end
