class Score::Criterias::RejectedByOwner < Score::Criterias::Base
  def self.ratio
    -100000
  end

  def calculate
    contact.additions_value('rejected_by_owner') ? 1 : 0
  end
end

