class Score::Criterias::ActivityOnZazo < Score::Criterias::Base
  def calculate
    contact.zazo_mkey ? get_activity : 0
  end

  private

  def get_activity
    0
  end
end
