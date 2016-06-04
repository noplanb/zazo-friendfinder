class Contact::Add < Contact::BaseHandler
  attr_accessor :phone_number

  def do
    if contact.added?
      { status: :already_added }
    else
      contact.update_attributes(additions: new_additions)
      emit_event(%w(contact added))
      invite_contact
    end
  end

  private

  def invite_contact
    case caller
      when :web_client
        Resque.enqueue(ResqueWorker::InviteContact, contact.id, caller)
        { status: :queued }
      when :api
        instance = Contact::Invite.new(contact, caller: caller)
        instance.phone_number = phone_number
        user_data = instance.do
        user_data ? user_data.merge(status: :added) : { status: :error }
    end
  end

  def new_additions
    (contact.additions || {}).except('ignored_by_owner').merge('added_by_owner' => true)
  end
end
