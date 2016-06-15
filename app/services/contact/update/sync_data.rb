class Contact::Update::SyncData
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def call
    Contact::Update::FindZazoContact.new(contact).do unless contact_is_zazo_user?
    Contact::Update::UpdateZazoInfo.new(contact).do if contact_is_zazo_user?
  end

  private

  def contact_is_zazo_user?
    contact.marked_as_friend?
  end
end
