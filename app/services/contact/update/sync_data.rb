class Contact::Update::SyncData
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def call
    Contact::Update::FindZazoContact.new(contact).do unless zazo_user?
    Contact::Update::UpdateZazoInfo.new(contact).do if zazo_user?
  end

  private

  def zazo_user?
    !!contact.zazo_mkey
  end
end
