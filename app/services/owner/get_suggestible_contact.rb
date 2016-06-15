class Owner::GetSuggestibleContact
  class NoContactToSuggest < Exception; end
  class ReachedSyncingLimit < Exception; end

  LIMIT_SYNCING_PER_CALL = 10

  attr_reader :owner

  def initialize(owner)
    @owner = owner
  end

  def call
    get_suggestible_contact
  rescue NoContactToSuggest, ReachedSyncingLimit
  end

  private

  def get_suggestible_contact
    contacts = owner.contacts.suggestible
    LIMIT_SYNCING_PER_CALL.times do |index|
      contact = contacts[index]
      fail(NoContactToSuggest) unless contact
      sync_contact(contact)
      return contact unless contact.marked_as_friend?
    end
    fail(ReachedSyncingLimit)
  end

  def sync_contact(contact)
    Contact::Update::SyncData.new(contact).call
  end
end
