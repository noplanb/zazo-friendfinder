class CronWorker::FakeUserJoinedNotification
  def self.perform
    WriteLog.info(self, 'cron job was executed')
    Owner.subscribed.each do |owner|
      contact = owner.contacts.not_proposed.not_friends_with_owner.first
      contact && Notification::Create.new(:fake_user_joined, contact).do.each { |n| n.send_notification }
    end
  end
end