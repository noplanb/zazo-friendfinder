class Contact::Ignore < Contact::BaseHandler
  def do
    if contact.ignored?
      return_status(:already_ignored)
    elsif contact.added?
      return_status(:already_added)
    else
      contact.update_attributes(additions: new_additions)
      emit_event(%w(contact ignored))
      return_status(:ignored)
    end
  end

  private

  def return_status(status)
    { status: status }
  end

  def new_additions
    (contact.additions || {}).merge('ignored_by_owner' => true)
  end
end
