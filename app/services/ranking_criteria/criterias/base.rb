class RankingCriteria::Criterias::Base
  def self.ratio
    1
  end

  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def save

  end

  def calculate
    0
  end

  def calculate_with_ratio
    self.class.ratio * calculate
  end
end
