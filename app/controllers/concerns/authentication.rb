module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = 'zazo.com'

  included do
    attr_accessor :current_client, :current_user
    before_action :authenticate
  end

  protected

  def authenticate
    authenticate_or_request_with_http_digest(REALM) do |mkey|
      Zazo::Tool::Logger.info(self, "authenticating user: #{mkey}")
      self.current_user = Owner.new(mkey)
      current_user = User.find(mkey)
      current_user && current_user.auth
    end
  end

  def request_http_digest_authentication(realm = REALM)
    super(realm, { status: :unauthorized }.to_json)
  end
end
