class ScoresRecalculationWorker
  def self.perform
    WriteLog.info self, "resque job was executed at #{Time.now}"
    Contact.expired.each do |contact|
      contact.scores.each { |score| score.destroy }
      Score::CalculationByContact.new(contact).do
    end
  end
end
