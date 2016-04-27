module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = 'zazo.com'


  included do
    attr_accessor :current_client, :current_user
    before_action :authenticate
  end

  protected

  def authenticate
    params[:auth_nkey] ? authenticate_with_nkey : authenticate_with_digest
  end

  def authenticate_with_nkey
    notification = Notification.find_by_nkey(params[:auth_nkey])
    if notification
      self.current_client = :web_client
      self.current_user = notification.contact.owner
    else
      render json: { status: :unauthorized }
    end
  end

  def authenticate_with_digest
    authenticate_or_request_with_http_digest(REALM) do |mkey|
      Zazo::Tools::Logger.info(self, "authenticating user: #{mkey}")
      self.current_client = :api
      self.current_user = User.find(mkey)
      current_user && current_user.auth
    end
  end

  def request_http_digest_authentication(realm = REALM)
    super(realm, { status: :unauthorized }.to_json)
  end
end
