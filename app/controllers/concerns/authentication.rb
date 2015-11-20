module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = AppConfig.app_name

  included do
    attr_accessor :current_client, :current_user
    before_action :authenticate
  end

  protected

  def authenticate
    WriteLog.info self, "trying authenticate with digest, params: #{params}"
    authenticate_with_digest
  end

  def authenticate_with_digest
    authenticate_or_request_with_http_digest(REALM) do |mkey|
      WriteLog.info self, "Authenticating user: #{mkey}"
      self.current_user = User.find(mkey)
      current_user && current_user.auth
    end
  end

  def request_http_digest_authentication(realm = REALM)
    super(realm, { status: :unauthorized }.to_json)
  end
end
