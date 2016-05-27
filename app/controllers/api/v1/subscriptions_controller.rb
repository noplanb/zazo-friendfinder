class Api::V1::SubscriptionsController < ApiController
  before_action :handle_action, only: %i(subscribe unsubscribe)

  def index
    handle_interactor(:render,
      Subscriptions::GetSubscriptionStatus.run(owner: current_user))
  end

  def subscribe
  end

  def unsubscribe
  end

  private

  def handle_action
    handle_interactor(:render,
      Subscriptions::HandleAction.run(owner: current_user, action: params[:action], caller: :api))
  end
end
