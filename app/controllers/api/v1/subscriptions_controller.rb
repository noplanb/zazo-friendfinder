class Api::V1::SubscriptionsController < ApiController
  before_action :set_owner

  def index
    render json: { status: :success,
                   data: { status: @owner.subscribed? ? 'subscribed' : 'unsubscribed' } }
  end

  def unsubscribe
    @owner.unsubscribe
    emit_event(%w(settings unsubscribed))
    render json: { status: :success }
  end

  def subscribe
    @owner.subscribe
    emit_event(%w(settings subscribed))
    render json: { status: :success }
  end

  private

  def set_owner
    @owner = Owner.new(current_user.mkey)
  end

  # TODO: it is bad to use code like this in controller, I need to refactor this in future

  def emit_event(name)
    Zazo::Tools::EventDispatcher.emit(name,
      triggered_by: 'ff:api',
      initiator: 'owner',
      initiator_id: @owner.mkey)
  end
end
