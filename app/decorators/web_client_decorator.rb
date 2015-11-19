class WebClientDecorator < Draper::Decorator
  delegate_all

  def contact_first_name
    contact_full_name.split(' ').first
  end

  def contact_full_name
    contact.display_name
  end

  def another_contacts
    contact.owner.not_proposed_contacts.first(3)
  end

  private

  def contact
    @contact ||= self.notifications.first.contact
  end
end
