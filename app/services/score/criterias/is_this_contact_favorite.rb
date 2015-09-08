class Score::Criterias::IsThisContactFavorite < Score::Criterias::Base
  def self.ratio
    10
  end

  def calculate
    contact.vectors.find do |vector|
      vector.additions_value 'marked_as_favorite'
    end.nil? ? 0 : 1
  end
end