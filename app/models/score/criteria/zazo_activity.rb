class Score::Criteria::ZazoActivity < Score::Criteria::Base
  def self.ratio
    4
  end

  def calculate
    contact.zazo_mkey ? get_activity : 0
  end

  private

  def get_activity
    api_params = { user: contact.zazo_mkey, attrs: [:friends] }
    DataProviderApi.new(api_params).query(:attributes)['friends'].size rescue 0
  end
end
