class Score::Criteria::NumVectors < Score::Criteria::Base
  def self.ratio
    1
  end

  def calculate
    contact.vectors.size
  end
end
