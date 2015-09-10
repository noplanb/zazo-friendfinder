class Score::Criterias::IsContactRegisteredOnZazo < Score::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    contact.zazo_id && contact.zazo_mkey ? 1 : 0
  end
end
