class Score::Criterias::SmsFrequency < Score::Criterias::Base
  def calculate
    contact.vectors.mobile.each do |vector|
      return vector.additions_value('messages_sent', 0)
    end && 0
  end
end
