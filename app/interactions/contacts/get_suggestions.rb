class Contacts::GetSuggestions < ActiveInteraction::Base
  RETURN_CONTACTS_COUNT = 10

  object :owner

  def execute
    contacts.map do |contact|
      ContactSerializer.new(contact, except: :vectors).serializable_hash
    end
  end

  private

  def contacts
    owner.contacts.not_added.not_ignored.not_friends.take(RETURN_CONTACTS_COUNT)
  end
end
