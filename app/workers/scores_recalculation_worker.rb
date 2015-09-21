class ScoresRecalculationWorker
  def self.perform
    Contact.expired.each do |contact|
      contact.scores.each { |score| score.destroy }
      Score::CalculationByContact.new(contact).do
    end
  end
end
