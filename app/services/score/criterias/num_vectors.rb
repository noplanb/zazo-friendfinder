class Score::Criterias::NumVectors < Score::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    contact.vectors.size
  end
end
