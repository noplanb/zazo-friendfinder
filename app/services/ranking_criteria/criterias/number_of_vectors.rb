class RankingCriteria::Criterias::NumberOfVectors < RankingCriteria::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    connection.vectors.size
  end
end
