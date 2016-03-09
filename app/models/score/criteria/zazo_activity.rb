class Score::Criteria::ZazoActivity < Score::Criteria::Base
  def self.ratio
    4
  end

  def calculate
    contact.zazo_mkey ? get_activity : 0
  end

  private

  def get_activity
    data = DataProviderApi.new(user_mkey: contact.zazo_mkey).query(:messages_count)
    data['active_friends'].to_i
  end
end
