class WebClient::ActionHandler
  include ActiveModel::Validations

  attr_reader :nkey, :caller, :notifications, :notice
  validate :nkey_should_be_correct

  def initialize(nkey, owner: nil, caller: :web_client)
    @nkey = nkey
    @owner = owner
    @caller = caller
    @notifications = Notification.by_nkey(nkey)
  end

  def owner
    @owner || notification.contact.owner
  end

  def notification
    notifications.first
  end

  #
  # actions
  #

  def add(contact = nil)
    emit_event(%w(notification added)) unless contact
    add_or_ignore(Contact::Add, contact, :added)
  rescue AASM::InvalidTransition
    if notification.added?
      @notice = NoticeBuilder.new(:added, :added, :already_added,
                                  contact_name: notification.contact.display_name).as_json
    end
  end

  def ignore(contact = nil)
    emit_event(%w(notification ignored)) unless contact
    add_or_ignore(Contact::Ignore, contact, :ignored)
  rescue AASM::InvalidTransition
    status = notification.status
    if %w(added ignored).include?(status)
      @notice = NoticeBuilder.new(status, status, "already_#{status}",
                                  contact_name: notification.contact.display_name).as_json
    end
  end

  def unsubscribe
    emit_event(%w(settings unsubscribed))
    subscribe_or_unsubscribe(:unsubscribe, :unsubscribed)
  end

  def subscribe
    emit_event(%w(settings subscribed))
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
    service.new(contact_to_handle, caller: caller).do
  end

  def subscribe_or_unsubscribe(action_method, new_status)
    if owner.send("#{new_status}?")
      @notice = NoticeBuilder.new(new_status, new_status, "already_#{new_status}").as_json
    else
      owner.send(action_method)
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

  #
  # events dispatching
  #

  def emit_event(name)
    Zazo::Tools::EventDispatcher.emit(name, build_event)
  end

  def build_event
    event = {
      triggered_by: "ff:#{caller}",
      initiator: 'owner',
      initiator_id: owner.mkey
    }
    event.merge!(
      target: 'notification',
      target_id: notification.nkey) if notification
    event
  end
end
