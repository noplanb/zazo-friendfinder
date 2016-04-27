module Authorization
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Digest::ControllerMethods

  REALM = 'zazo.com'
  AUTHORIZATION = {
    web_client: {
      'api/v1/contacts' => %w(add ignore),
      'api/v1/notifications' => %w(add ignore),
      'api/v1/suggestions' => %w(index)
    },
    api: :all
  }

  included do
    attr_accessor :current_client, :current_user
    before_action :authenticate, :authorize
  end

  protected

  #
  # authentication
  #

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

  #
  # authorization
  #

  def authorize
    render json: { status: :unauthorized } unless authorized?
  end

  def authorized?
    controller = params[:controller]
    action     = params[:action]
    AUTHORIZATION[current_client] == :all ||
      AUTHORIZATION[current_client][controller].include?(action)
  rescue NoMethodError
    false
  end
end
