class Contact::SetZazoIdAndMkeyByOwnerContacts
  attr_reader :owner

  def initialize(owner)
    @owner = Owner.new(owner)
  end

  def do
    owner.contacts.map { |contact| Contact::SetZazoIdAndMkeyByContact.new(contact).do }
  end
end
