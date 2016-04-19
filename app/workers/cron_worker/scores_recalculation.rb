class CronWorker::ScoresRecalculation
  def self.perform
    Zazo::Tools::Logger.info(self, 'started')
    Contact.expired.each do |contact|
      contact.scores.destroy_all
      Score::CalculationByContact.new(contact).do
    end
  end
end
