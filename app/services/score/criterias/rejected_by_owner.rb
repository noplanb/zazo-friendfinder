class Score::Criterias::RejectedByOwner < Score::Criterias::Base
  def self.ratio
    -100000
  end

  def calculate
    additions = contact.additions || {}
    additions['rejected_by_owner'] ? 1 : 0
  end
end

