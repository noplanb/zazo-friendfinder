class Contact::SetZazoIdAndMkeyByOwnerContacts
  attr_reader :owner

  def initialize(owner)
    @owner = owner
  end

  def do
    Contact.by_owner(owner).map { |contact| Contact::SetZazoIdAndMkeyByContact.new(contact).do }
  end
end
