class Notifications::HandleAction < ActiveInteraction::Base
  string :action
  symbol :caller
  array :notifications do
    object class: Notification
  end
  string :phone_number, default: ''

  validates :action, inclusion: { in: %w(add ignore),
                                  message: '%{value} is not a allowed action' }

  def execute
    update_notifications
    compose(Contacts::HandleAction,
      inputs.except(:notifications).merge(contact: notification.contact))
  end

  private

  def update_notifications
    notifications.each do |notification|
      notification.send("set_#{new_status}")
      notification.save
    end
    emit_event
    new_status
  rescue AASM::InvalidTransition
    new_status == :added ? :already_added : :"already_#{notification.status}"
  end

  def emit_event
    DispatchEvent.new(caller,
      ['notification', new_status.to_s],
      [notification.contact.owner, notification]).do
  end

  #
  # helpers
  #

  def notification
    notifications.first
  end

  def new_status
    @new_status ||= action == 'add' ? :added : :ignored
  end
end
