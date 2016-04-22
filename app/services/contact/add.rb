class Contact::Add < Contact::BaseHandler
  def do
    unless contact.added?
      contact.update_attributes(additions: new_attributes)
      emit_event(%w(contact added))
      Resque.enqueue(ResqueWorker::InviteContact, contact.id, caller) unless Rails.env.production?
    end
  end

  private

  def new_attributes
    (contact.additions || {}).except('ignored_by_owner').merge('added_by_owner' => true)
  end
end
