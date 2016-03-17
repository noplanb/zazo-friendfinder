class Admin::Contacts
  attr_reader :contact

  def initialize(contact)
    @contact = contact.kind_of?(Integer) ? Contact.find(contact) : contact
  end
end
