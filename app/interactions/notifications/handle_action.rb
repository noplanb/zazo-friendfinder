class Notifications::HandleAction < ActiveInteraction::Base
  string :action
  symbol :caller
  array :notifications do
    object class: Notification
  end

  validates :action, inclusion: { in: %w(add ignore),
                                  message: '%{value} is not a allowed action' }

  def execute
    { notification: { status: update_notifications },
      contact: handle_related_contact }
  end

  private

  def update_notifications
    notifications.each do |notification|
      notification.send("set_#{new_status}")
      notification.save
    end
    new_status
  rescue AASM::InvalidTransition
    new_status == :added ? :already_added : :"already_#{notifications.first.status}"
  end

  def handle_related_contact
    contact = notifications.first.contact
    service = action == 'add' ? Contact::Add : Contact::Ignore
    service.new(contact, caller: caller).do
  end

  def new_status
    @new_status ||= action == 'add' ? :added : :ignored
  end
end
