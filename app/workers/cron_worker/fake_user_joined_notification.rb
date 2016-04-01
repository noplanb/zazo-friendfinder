class CronWorker::FakeUserJoinedNotification
  def self.perform
    WriteLog.info(self, 'started')
    Owner.subscribed.each do |owner|
      contact = owner.contacts.suggestible.first
      contact && Notification::Create.new(:fake_user_joined, contact).do.each { |n| n.send_notification }
    end
  end
end
