class Score::Criterias::ZazoActivity < Score::Criterias::Base
  def calculate
    contact.zazo_mkey ? get_activity : 0
  end

  private

  def get_activity
    data = EventsApi.new(user_mkey: contact.zazo_mkey).metric :messages_count_by_user
    (data['outgoing'].to_i + data['incoming'].to_i) / 30 + data['active_friends'].to_i
  end
end
