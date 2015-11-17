# cron worker

class Notification::UserJoinedWorker
  def self.perform
    WriteLog.info self, "cron job was executed at #{Time.now}"
    recently_joined_users.each do |contact_data|
      Contact::FindOwnersByContactMatching.new(contact_data).do.each do |contact|
        Notification::Send.new(Notification::Create.new(:user_joined, contact).do).do unless Notification.match_by_contact?(contact)
      end
    end
  end

  private

  def self.recently_joined_users
    StatisticsApi.new(time_frame_in_days: '3').users :recently_joined
  end
end
