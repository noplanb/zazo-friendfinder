class Api::V1::SubscriptionsController < ApiController
  before_action :set_owner
  before_action :set_web_client, only: %i(unsubscribe subscribe)

  def index
    render json: { status: :success,
                   data: { status: @owner.subscribed? ? 'subscribed' : 'unsubscribed' } }
  end

  def unsubscribe
    @web_client.unsubscribe
    render json: { status: :success }
  end

  def subscribe
    @web_client.subscribe
    render json: { status: :success }
  end

  private

  def set_owner
    @owner = Owner.new(current_user.mkey)
  end

  def set_web_client
    @web_client = WebClient::ActionHandler.new(nil, owner: @owner, caller: :api)
  end
end
