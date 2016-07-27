class Score::CalculationByContact
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    contact.scores.destroy_all
    contact.total_score = save_scores_and_get_total
    contact.save
  end

  private

  def save_scores_and_get_total
    total_score = 0
    wrap_transaction do
      criteria.each { |instance| total_score += instance.save.value }
    end
    total_score < 0 ? 0 : total_score
  end

  def wrap_transaction
    Score.transaction { yield }
  end

  def criteria
    Score::ALLOWED_METHODS.map do |name|
      Zazo::Tool::Classifier.new([:score, :criteria, name]).klass.new(contact)
    end
  end
end
