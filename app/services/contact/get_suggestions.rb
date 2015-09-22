class Contact::GetSuggestions
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def do
    WriteLog.info self, "suggestions sent at #{Time.now} to '#{current_user.mkey}' owner"
    contacts.map do |contact|
      ContactSerializer.new(contact).serializable_hash
    end
  end

  private

  def contacts
    Contact.by_owner current_user.mkey
  end
end
