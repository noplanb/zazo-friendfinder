class Contact::GetSuggestions
  RETURN_CONTACTS_COUNT = 100

  attr_reader :owner

  def initialize(owner_mkey)
    @owner = Owner.new(owner_mkey)
  end

  def do
    WriteLog.info(self, "suggestions was sent to owner=#{owner.mkey}")
    contacts.map { |contact| ContactSerializer.new(contact).serializable_hash }
  end

  private

  def contacts
    owner.contacts.not_friends.take(RETURN_CONTACTS_COUNT)
  end
end
