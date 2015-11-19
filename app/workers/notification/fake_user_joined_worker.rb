# cron worker

class Notification::FakeUserJoinedWorker
  def self.perform
    WriteLog.info self, "cron job was executed at #{Time.now}"
    Contact.uniq.pluck(:owner).each do |owner|
      contact = Owner.new(owner).contacts.select { |contact| !Notification.match_by_contact?(contact) }.first
      contact && Notification::Send.new(Notification::Create.new(:fake_user_joined, contact).do).do
    end
  end
end
