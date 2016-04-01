class Score::Criteria::IgnoredByOwner < Score::Criteria::Base
  def self.ratio
    -100000
  end

  def calculate
    contact.additions_value('ignored_by_owner') ? 1 : 0
  end
end

