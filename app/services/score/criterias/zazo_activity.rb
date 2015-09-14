class Score::Criterias::ZazoActivity < Score::Criterias::Base
  def self.ratio
    4
  end

  def calculate
    contact.zazo_mkey ? get_activity : 0
  end

  private

  def get_activity
    data = EventsApi.new(user_mkey: contact.zazo_mkey).metric :messages_count_by_user
    data['active_friends'].to_i
  end
end
