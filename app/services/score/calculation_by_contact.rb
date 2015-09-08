class Score::CalculationByContact
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    contact.total_score = save_scores_and_get_total
    contact.save!
  end

  private

  def save_scores_and_get_total
    total_score = 0
    wrap_transaction do
      criterias.each do |calculated|
        score = Score.create({
          contact: contact,
          name:  calculated[:name],
          value: calculated[:score]
        })
        total_score += score.value if score.persisted?
      end
    end
    total_score
  end

  def wrap_transaction
    Score.transaction { yield }
  end

  def criterias
    Score::ALLOWED_METHODS.map do |name|
      criteria = Classifier.new([:score, :criterias, name]).klass
      { name: name, score: criteria.new(contact).calculate_with_ratio }
    end
  end
end
