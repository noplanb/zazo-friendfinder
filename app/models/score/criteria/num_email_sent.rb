class Score::Criteria::NumEmailSent < Score::Criteria::Base
  def self.ratio
    16
  end

  def calculate
    contact.vectors.email.each do |vector|
      messages_sent = vector.additions_value('email_messages_sent', 0).to_i
      return (1 + (messages_sent / 20.0)) if messages_sent > 0
    end && 0
  end
end
