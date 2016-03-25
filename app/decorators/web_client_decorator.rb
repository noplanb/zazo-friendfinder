class WebClientDecorator < Draper::Decorator
  delegate_all

  def owner_full_name
    contact.owner.fetch_data.full_name
  end

  def others_contacts
    contact.owner.contacts.suggestible.limit(8).decorate
  end

  def notification
    self.notifications.first
  end

  def contact
    @contact ||= notification.contact.decorate
  end

  def action_link(status)
    status == 'unsubscribed' ? subscribe_link : got_it_link
  end

  def contact_placeholder
    h.image_tag("web_client/placeholders/#{(1..5).to_a.sample}.png", class: 'placeholder')
  end

  def unsubscribed_placeholder
    h.image_tag('web_client/unsubscribed_placeholder.png', class: 'placeholder')
  end

  def subscribed_placeholder
    h.image_tag('web_client/subscribed_placeholder.png', class: 'placeholder')
  end

  private

  def subscribe_link
    h.link_to('subscribe', h.subscribe_web_client_path(notification.nkey))
  end

  def got_it_link
    h.link_to('got it', '#got_it', id: 'got_it')
  end
end
