class WebClientDecorator < Draper::Decorator
  delegate_all

  def do(action)
    object.do(action)
  rescue WebClient::ContactAlreadyAdded
    @extended_status = :ignore_after_adding
  end

  def status
    notification.status
  end

  def extended_status
    @extended_status || notification.status
  end

  def owner_full_name
    contact.owner.fetch_data.full_name
  end

  def others_contacts
    contacts = contact.owner.contacts.not_proposed.not_friends_with_owner.first(8)
    ContactsDecorator.decorate_collection(contacts)
  end

  def notification
    self.notifications.first
  end

  def contact
    @contact ||= ContactsDecorator.decorate(notification.contact)
  end

  def action_link
    notification.unsubscribed? ? subscribe_link : got_it_link
  end

  def placeholder_icon(classes = '')
    h.image_tag("web_client/placeholders/#{(1..5).to_a.sample}.png", class: classes)
  end

  private

  def subscribe_link
    h.link_to('subscribe', h.subscribe_web_client_path(notification.nkey))
  end

  def got_it_link
    h.link_to('got it', h.web_client_path(notification.nkey))
  end
end
