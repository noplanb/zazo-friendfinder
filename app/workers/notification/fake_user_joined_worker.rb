# cron worker

class Notification::FakeUserJoinedWorker
  def self.perform
    WriteLog.info(self, 'cron job was executed')
    Owner.subscribed.each do |owner|
      contact = owner.contacts.not_proposed.first
      contact && Notification::Create.new(:fake_user_joined, contact).do.each { |n| n.send_notification }
    end
  end
end
