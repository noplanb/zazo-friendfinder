class Contact::Add
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    # TODO: add contact via sending api request to zazo-prod worker
    contact.update_attributes(additions: new_attributes) unless contact.added?
  end

  def new_attributes
    (contact.additions || {}).except('rejected_by_owner').merge('added_by_owner' => true)
  end
end
