class WebClientDecorator < Draper::Decorator
  delegate_all

  def others_contacts
    ContactsDecorator.decorate_collection contact.owner.not_proposed_contacts.first(8)
  end

  def notification
    self.notifications.first
  end

  def contact
    @contact ||= ContactsDecorator.decorate notification.contact
  end

  def action_link
    notification.status == 'unsubscribed' ? subscribe_link : got_it_link
  end

  def placeholder_icon(classes = '')
    h.image_tag("web_client/placeholders/#{(1..5).to_a.sample}.png", class: classes)
  end

  private

  def subscribe_link
    h.link_to 'subscribe', h.subscribe_web_client_path(notification.nkey)
  end

  def got_it_link
    h.link_to 'got it', 'javascript:void(0)', data: { notify: 'dismiss' }
  end
end
