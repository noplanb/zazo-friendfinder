class User
  class NotFound < Exception; end

  attr_accessor :mkey, :auth

  class << self
    def find(mkey)
      data = get_user_data(mkey)
      new mkey: mkey, auth: data['mkey']
    rescue NotFound
      nil
    end

    def get_user_data(mkey)
      StatisticsApi.new(user: mkey, attrs: [:mkey]).attributes
      # todo: change :mkey with :auth
    rescue Faraday::ClientError
      raise NotFound, "user with #{mkey} not found"
    end
  end

  def initialize(attrs = {})
    self.mkey = attrs[:mkey]
    self.auth = attrs[:auth]
  end
end
