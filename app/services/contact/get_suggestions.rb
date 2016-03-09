class Contact::GetSuggestions
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
    Contact.by_owner(owner_mkey)
  end
end
