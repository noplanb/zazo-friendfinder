# cron worker

class ScoresRecalculationWorker
  def self.perform
    WriteLog.info(self, 'cron job was executed')
    Contact.expired.each do |contact|
      contact.scores.each(&:destroy)
      Score::CalculationByContact.new(contact).do
    end
  end
end
