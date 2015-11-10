module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = AppConfig.app_name

  included do
    attr_accessor :current_client
    attr_accessor :current_user

    before_action :authenticate
  end

  protected

  def authentication_method
    :digest
  end

  def authenticate
    WriteLog.info self, "Trying authenticate with #{authentication_method.inspect}"
    send "authenticate_with_#{authentication_method}"
  end

  def authenticate_with_basic
    authenticate_or_request_with_http_basic(REALM) do |username, password|
      WriteLog.info self, "Authenticating client: #{username}"
      self.current_client = username
      Credentials.password_for(username) == password
    end
  end

  def authenticate_with_digest
    authenticate_or_request_with_http_digest(REALM) do |mkey|
      WriteLog.info self, "Authenticating user: #{mkey}"
      self.current_user = User.find(mkey)
      current_user && current_user.auth
    end
  end

  def request_http_basic_authentication(realm = REALM)
    headers['WWW-Authenticate'] = %(Basic realm="#{realm.gsub(/"/, '')}")
    render json: { status: :unauthorized }, status: :unauthorized
  end

  def request_http_digest_authentication(realm = REALM)
    super(realm, { status: :unauthorized }.to_json)
  end
end
