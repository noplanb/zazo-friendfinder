class Contact::Ignore
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    unless contact.ignored? || contact.added?
      contact.update_attributes(additions: new_attributes)
    end
  end

  private

  def new_attributes
    (contact.additions || {}).merge('ignored_by_owner' => true)
  end
end
