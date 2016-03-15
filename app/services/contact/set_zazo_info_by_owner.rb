class Contact::SetZazoInfoByOwner
  attr_reader :owner

  def initialize(owner)
    @owner = Owner.new(owner)
  end

  def do
    owner.contacts.map { |contact| Contact::SetZazoInfoByContact.new(contact).do }
  end
end
