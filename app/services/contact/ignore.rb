class Contact::Ignore
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    contact.update_attributes(additions: new_attributes) unless contact.ignored? || contact.added?
  end

  private

  def new_attributes
    (contact.additions || {}).merge('ignored_by_owner' => true)
  end
end
