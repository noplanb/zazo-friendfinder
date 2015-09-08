class RankingCriteria::Criterias::SmsFrequency < RankingCriteria::Criterias::Base
  def calculate
    connection.vectors.mobile.each do |vector|
      return vector.additions_value('messages_sent', 0)
    end && 0
  end
end
