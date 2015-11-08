# cron worker

class Notification::FakeUserJoinedWorker
  def self.perform
    WriteLog.info self, "cron job was executed at #{Time.now}"
  end
end
