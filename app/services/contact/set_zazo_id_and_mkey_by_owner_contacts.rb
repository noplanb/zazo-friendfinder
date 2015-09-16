class Contact::SetZazoIdAndMkeyByOwnerContacts
  include PerformAsync
  allow_async :do

  attr_reader :owner

  def initialize(owner)
    @owner = owner
  end

  def do
    Contact.by_owner(owner).map { |contact| Contact::SetZazoIdAndMkeyByContact.new(contact).do }
  end
end
