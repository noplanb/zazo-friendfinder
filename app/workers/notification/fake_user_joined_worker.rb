# cron worker

class Notification::FakeUserJoinedWorker
  def self.perform
    WriteLog.info self, "cron job was executed at #{Time.now}"
    Owner.subscribed.each do |owner|
      contact = owner.not_proposed_contacts.first
      contact && Notification::Send.new(Notification::Create.new(:fake_user_joined, contact).do).do
    end
  end
end
