class RankingCriteria::Criterias::Base
  RATIO = 1

  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def save

  end

  def calculate
    0
  end
end
