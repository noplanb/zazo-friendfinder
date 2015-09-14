class Score::Criterias::RecommendedByFriends < Score::Criterias::Base
  def self.ratio
    24
  end

  def calculate
    additions = contact.additions || {}
    additions['recommended_by'].try(:size) || 0
  end
end
