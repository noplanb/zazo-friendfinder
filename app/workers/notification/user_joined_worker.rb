# cron worker

class Notification::UserJoinedWorker
  def self.perform
    WriteLog.info self, "cron job was executed at #{Time.now}"
  end
end
