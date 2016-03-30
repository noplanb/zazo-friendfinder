class Contact::Update::SetZazoInfoByOwner
  attr_reader :owner

  def initialize(owner_mkey)
    @owner = Owner.new(owner_mkey)
  end

  def do
    owner.contacts.map { |contact| Contact::Update::SetZazoInfoByContact.new(contact).do }
  end
end
