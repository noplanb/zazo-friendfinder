class Score::Criterias::ContactOfFriends < Score::Criterias::Base
  def self.ratio
    8
  end

  def calculate
    0
  end

  private

  def query
    <<-SQL

    SQL
  end
end
