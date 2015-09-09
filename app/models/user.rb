class User
  class NotFound < Exception; end

  attr_accessor :mkey, :auth

  def self.find(mkey)
    data = get_user_data(mkey)
    new mkey: mkey, auth: data['auth']
  rescue NotFound
    nil
  end

  def self.get_user_data(mkey)
    StatisticsApi.new(user: mkey, attrs: [:mkey, :auth]).attributes
  rescue Faraday::ClientError
    raise NotFound, "user with #{mkey} not found"
  end

  def initialize(attrs = {})
    self.mkey = attrs[:mkey]
    self.auth = attrs[:auth]
  end
end
