class Subscriptions::GetSubscriptionStatus < ActiveInteraction::Base
  object :owner

  def execute
    { status: owner.subscribed? ? 'subscribed' : 'unsubscribed' }
  end
end
