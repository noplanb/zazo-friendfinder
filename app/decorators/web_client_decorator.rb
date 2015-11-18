class WebClientDecorator < Draper::Decorator
  delegate_all

  def contact_first_name
    contact_full_name.split(' ').first
  end

  def contact_full_name
    contact.display_name
  end

  def another_contacts
    Contact.by_owner(contact.owner).select { |contact| !Notification.match_by_contact?(contact) }.first(3)
  end

  private

  def contact
    self.notifications.first.contact
  end
end
