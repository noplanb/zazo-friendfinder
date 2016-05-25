class Contact::Ignore < Contact::BaseHandler
  def do
    if contact.ignored?
      :already_ignored
    elsif contact.added?
      :already_added
    else
      contact.update_attributes(additions: new_additions)
      emit_event(%w(contact ignored))
      :ignored
    end
  end

  private

  def new_additions
    (contact.additions || {}).merge('ignored_by_owner' => true)
  end
end
