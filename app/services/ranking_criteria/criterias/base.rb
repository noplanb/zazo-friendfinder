class RankingCriteria::Criterias::Base
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def save

  end

  def calculate

  end
end
