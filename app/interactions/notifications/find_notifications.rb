class Notifications::FindNotifications < ActiveInteraction::Base
  string :nkey

  def execute
    notifications = Notification.where(nkey: nkey)
    errors.add(:nkey, 'nkey is incorrect') if notifications.empty?
    notifications
  end
end
