class Contact::Ignore < Contact::BaseHandler
  def do
    unless contact.ignored? || contact.added?
      contact.update_attributes(additions: new_attributes)
      emit_event(%w(contact ignored))
    end
  end

  private

  def new_attributes
    (contact.additions || {}).merge('ignored_by_owner' => true)
  end
end
