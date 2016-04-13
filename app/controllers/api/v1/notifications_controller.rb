class Api::V1::NotificationsController < ApiController
  before_action :set_web_client

  def show
    render json: { status: :success,
                   data: NotificationSerializer.new(@web_client.notification).serializable_hash }
  end

  def add
    handle_action(:add)
  end

  def ignore
    handle_action(:ignore)
  end

  private

  def handle_action(action)
    @web_client.send(action)
    render json: { status: :success }
  end

  def set_web_client
    @web_client = WebClient::ActionHandler.new(params[:id], caller: :api)
    render status: :unprocessable_entity, json: { status: :failure, errors: @web_client.errors } unless @web_client.valid?
  end
end
