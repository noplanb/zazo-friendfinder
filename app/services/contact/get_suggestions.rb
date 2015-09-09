class Contact::GetSuggestions
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def do
    contacts.map do |contact|
      ContactSerializer.new(contact).serializable_hash
    end
  end

  private

  def contacts
    Contact.by_owner current_user.mkey
  end
end
