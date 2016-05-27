class Notifications::GetNotificationData < ActiveInteraction::Base
  object :notification

  def execute
    NotificationSerializer.new(notification).serializable_hash
  end
end
