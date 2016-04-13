class Contact::Add < Contact::BaseHandler
  def do
    # TODO: add contact via sending api request to zazo-prod worker
    unless contact.added?
      contact.update_attributes(additions: new_attributes)
      emit_event(%w(contact added))
    end
  end

  private

  def new_attributes
    (contact.additions || {}).except('ignored_by_owner').merge('added_by_owner' => true)
  end
end
