class Api::V1::NotificationsController < ApiController
  before_action :set_web_client

  def add
    handle_action(:added)
  end

  def ignore
    handle_action(:ignored)
  end

  def unsubscribe
    handle_action(:unsubscribed)
  end

  def subscribe
    handle_action(nil)
  end

  private

  def handle_action(action)
    @web_client.do(action)
    render json: { status: :success }
  end

  def set_web_client
    @web_client = WebClient::ActionHandler.new(params[:id])
    unless @web_client.valid?
      render status: :unprocessable_entity, json: { status: :failure, errors: @web_client.errors }
    end
  end
end
