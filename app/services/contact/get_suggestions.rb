class Contact::GetSuggestions
  RETURN_CONTACTS_COUNT = 100

  attr_reader :owner_mkey

  def initialize(owner_mkey)
    @owner_mkey = owner_mkey
  end

  def do
    WriteLog.info(self, "suggestions was sent to owner=#{owner_mkey}")
    contacts.map { |contact| ContactSerializer.new(contact).serializable_hash }
  end

  private

  def contacts
    Contact.by_owner(owner_mkey).select { |c| !c.marked_as_friend? }.take(RETURN_CONTACTS_COUNT)
  end
end
