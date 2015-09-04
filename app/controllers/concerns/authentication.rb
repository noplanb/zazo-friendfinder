module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = Settings.app_name

  included do
    attr_accessor :current_client
    before_action :authenticate
  end

  protected

  def authentication_method
    Settings.authentication_method || :digest
  end

  def test
    current_client
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
    authenticate_or_request_with_http_digest(REALM) do |username|
      WriteLog.info self, "Authenticating client: #{username}"
      self.current_client = username
      Credentials.password_for(username)
    end
  end

  def request_http_basic_authentication(realm = REALM)
    headers['WWW-Authenticate'] = %(Basic realm="#{realm.gsub(/"/, '')}")
    render json: { status: :unauthorized }, status: :unauthorized
  end
end
