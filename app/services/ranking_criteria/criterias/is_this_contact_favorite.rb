class RankingCriteria::Criterias::IsThisContactFavorite < RankingCriteria::Criterias::Base
  RATIO = 10

  def calculate
    RATIO * (connection.vectors.find do |vector|
      vector.additions.try :[], 'marked_as_favorite'
    end.nil? ? 0 : 1)
  end
end
