class WebClient::ActionHandler
  include ActiveModel::Validations

  attr_reader :nkey, :notifications
  validate :nkey_should_be_correct

  def initialize(nkey)
    @nkey = nkey
    @notifications = Notification.find_notifications(nkey)
  end

  def do(action)
    notifications.each do |notification|
      notification.status = action && action.to_s
      Notification::Save.new(notification).do
    end
  end

  private

  def nkey_should_be_correct
    errors.add(:nkey, 'nkey is incorrect') if notifications.empty?
  end
end
