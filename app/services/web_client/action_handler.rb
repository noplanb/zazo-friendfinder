class WebClient::ActionHandler
  include ActiveModel::Validations

  attr_reader :nkey, :notifications
  validate :nkey_should_be_correct

  def initialize(nkey)
    @nkey = nkey
    @notifications = Notification.by_nkey(nkey)
  end

  def do(action)
    if already_added? && action == :ignored
      fail(WebClient::ContactAlreadyAdded)
    else
      update_status(action)
    end
  end

  private

  def already_added?
    @notifications.first.added?
  end

  def update_status(status)
    notifications.each do |notification|
      notification.status = status && status.to_s
      Notification::Save.new(notification).do
    end
  end

  def nkey_should_be_correct
    errors.add(:nkey, 'nkey is incorrect') if notifications.empty?
  end
end
