class Contact::GetSuggestions
  RETURN_CONTACTS_COUNT = 10

  attr_reader :owner

  def initialize(owner_mkey)
    @owner = Owner.new(owner_mkey)
  end

  def do
    contacts.map do |contact|
      ContactSerializer.new(contact, except: :vectors).serializable_hash
    end
  end

  private

  def contacts
    owner.contacts.not_added.not_ignored.not_friends.take(RETURN_CONTACTS_COUNT)
  end
end
