class BaseApi
  class << self
    attr_reader :api_version,
                :api_base_uri,
                :api_auth_name,
                :api_auth_token,
                :api_raise_errors,
                :api_map

    def version(version)
      @api_version = version
    end

    def base_uri(uri)
      @api_base_uri = uri
    end

    def mapper(map)
      @api_map = map
    end

    def digest_auth(name, token)
      @api_auth_name  = name
      @api_auth_token = token
    end

    def auth_token(token)
      @api_auth_token = token
    end

    def raise_errors(value)
      @api_raise_errors = value
    end
  end

  attr_reader :connection, :options,
              :api_auth_name, :api_auth_token

  def initialize(options = {})
    @options = options
    set_connection
  end

  def digest_auth(name, token)
    @api_auth_name = name
    @api_auth_token = token
    set_connection
  end

  def method_missing(method, *args)
    if map.key? method
      connection.send(*params(method, args[0]), options).body
    else
      connection.send(*params(:default, args[0]), options).body
    end
  end

  protected

  def set_connection
    @connection = Faraday.new(self.class.api_base_uri) do |c|
      c.request(:json)
      c.response(:json, content_type: /\bjson$/)
      c.response(:raise_error) if raise_errors?
      c.request(:digest, auth_credentials(:name), auth_credentials(:token)) if auth_credentials(:token)
      c.adapter(Faraday.default_adapter)
      c.use(Faraday::Response::Logger, Logger.new('log/faraday.log'))
    end
  end

  def map
    self.class.api_map
  end

  def auth_credentials(key)
    if key == :token
      token = self.class.api_auth_token || api_auth_token
      token ? URI::encode(token) : nil
    else
      self.class.api_auth_name || api_auth_name
    end
  end

  def raise_errors?
    val = self.class.api_raise_errors
    val.nil? ? true : val
  end

  def params(method, name)
    [map[method][:action], path(map[method][:prefix], name)]
  end

  def namespace
    self.class.api_version ? "api/v#{self.class.api_version}" : ""
  end

  def path(prefix, name)
    File.join [namespace, prefix, name].compact.map &:to_s
  end
end
