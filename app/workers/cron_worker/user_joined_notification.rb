class CronWorker::UserJoinedNotification
  def self.perform
    Zazo::Tools::Logger.info(self, 'started')
    recently_joined_users.each do |contact_data|
      Contact::FindOwnersByContactMatching.new(contact_data).do.each do |contact|
        unless contact.owner.unsubscribed? || contact.notified?
          Notification::Create.new(:user_joined, contact).do.each { |n| n.send_notification }
        end
      end
    end
  end

  private

  def self.recently_joined_users
    DataProviderApi.new(time_frame_in_days: '3').filter(:recently_joined)
  end
end
