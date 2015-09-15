class Score::Criterias::IsFavorite < Score::Criterias::Base
  def self.ratio
    48
  end

  def calculate
    contact.additions_value('marked_as_favorite') ? 1 : 0
  end
end
