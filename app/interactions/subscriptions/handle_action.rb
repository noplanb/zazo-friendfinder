class Subscriptions::HandleAction < ActiveInteraction::Base
  object :owner
  string :action
  symbol :caller
  object :notification, default: nil

  validates :action, inclusion: { in: %w(subscribe unsubscribe),
                                  message: '%{value} is not a allowed action' }

  def execute
    if owner.send("#{new_status}?")
      { status: :"already_#{new_status}" }
    else
      owner.send(action)
      emit_event
      { status: new_status }
    end
  end

  private

  def new_status
    @new_status ||= case action
      when 'subscribe' then :subscribed
      else :unsubscribed
    end
  end

  def emit_event
    DispatchEvent.new(caller, ['settings', new_status.to_s], [owner, notification]).do
  end
end
