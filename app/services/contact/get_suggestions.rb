class Contact::GetSuggestions
  attr_reader :current_user_mkey

  def initialize(current_user_mkey)
    @current_user_mkey = current_user_mkey
  end

  def do
    WriteLog.info(self, "suggestions was sent to current_user=#{current_user_mkey}")
    contacts.map { |contact| ContactSerializer.new(contact).serializable_hash }
  end

  private

  def contacts
    Contact.by_owner(current_user_mkey)
  end
end
