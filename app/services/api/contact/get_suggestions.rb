class Api::Contact::GetSuggestions < Api::BaseHandler
  RETURN_CONTACTS_COUNT = 10

  def do_safe
    @data = contacts.map do |contact|
      ContactSerializer.new(contact, except: :vectors).serializable_hash
    end
  end

  def log_messages(*)
  end

  private

  def contacts
    Owner.new(owner_mkey).contacts.not_added.not_ignored.not_friends.take(RETURN_CONTACTS_COUNT)
  end
end
