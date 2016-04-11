class Api::V1::SubscriptionsController < ApiController
  before_action :set_owner

  def index
    render json: { status: :success,
                   data: { status: @owner.subscribed? ? 'subscribed' : 'unsubscribed' } }
  end

  def unsubscribe
    @owner.unsubscribe
    render json: { status: :success }
  end

  def subscribe
    @owner.subscribe
    render json: { status: :success }
  end

  private

  def set_owner
    @owner = Owner.new(current_user.mkey)
  end
end
