class WebClient::ActionHandler
  include ActiveModel::Validations

  attr_reader :nkey, :notifications, :notice
  validate :nkey_should_be_correct

  def initialize(nkey)
    @nkey = nkey
    @notifications = Notification.by_nkey(nkey)
  end

  def owner
    notification.contact.owner
  end

  def notification
    notifications.first
  end

  #
  # actions
  #

  def add(contact = nil)
    add_or_ignore(WebClient::AddContact, contact, :added)
  rescue AASM::InvalidTransition
    if notification.added?
      @notice = NoticeBuilder.new(:added, :added, :already_added,
                                  contact_name: notification.contact.display_name).as_json
    end
  end

  def ignore(contact = nil)
    add_or_ignore(WebClient::IgnoreContact, contact, :ignored)
  rescue AASM::InvalidTransition
    status = notification.status
    if %w(added ignored).include?(status)
      @notice = NoticeBuilder.new(status, status, "already_#{status}",
                                  contact_name: notification.contact.display_name).as_json
    end
  end

  def unsubscribe
    subscribe_or_unsubscribe(:unsubscribe, :unsubscribed)
  end

  def subscribe
    subscribe_or_unsubscribe(:subscribe, :subscribed)
  end

  private

  #
  # action helpers
  #

  def add_or_ignore(service, contact, new_status)
    contact_to_handle = contact || notification.contact
    @notice = NoticeBuilder.new(new_status, new_status, new_status,
                                contact_name: contact_to_handle.display_name).as_json

    update_status(new_status) unless contact
    service.new(contact_to_handle).do
  end

  def subscribe_or_unsubscribe(action_method, new_status)
    if notification.contact.owner.send("#{new_status}?")
      @notice = NoticeBuilder.new(new_status, new_status, "already_#{new_status}").as_json
    else
      notification.contact.owner.send(action_method)
      @notice = NoticeBuilder.new(new_status, new_status, new_status).as_json
    end
  end

  def update_status(status)
    notifications.each do |notification|
      notification.send("set_#{status}")
      Notification::Save.new(notification).do
    end
  end

  #
  # validations
  #

  def nkey_should_be_correct
    errors.add(:nkey, 'nkey is incorrect') if notifications.empty?
  end
end
