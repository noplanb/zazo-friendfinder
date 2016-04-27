module Authorization
  extend ActiveSupport::Concern

  AUTHORIZATION = {
    web_client: {
      'api/v1/notifications' => %w(add ignore)
    },
    api: :all
  }

  included do
    attr_accessor :current_client
    before_action :authorize
  end

  protected

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
