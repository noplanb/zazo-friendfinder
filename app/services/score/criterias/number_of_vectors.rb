class Score::Criterias::NumberOfVectors < Score::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    contact.vectors.size
  end
end
