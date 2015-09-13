class Score::Criterias::IsFavorite < Score::Criterias::Base
  def self.ratio
    48
  end

  def calculate
    contact.vectors.find do |vector|
      vector.additions_value 'marked_as_favorite'
    end.nil? ? 0 : 1
  end
end
