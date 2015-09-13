class Score::Criterias::NumVectors < Score::Criterias::Base
  def self.ratio
    1
  end

  def calculate
    contact.vectors.size
  end
end
