class Contact::ControllerManager::GetInfo < Contact::ControllerManager::BaseHandler
  def do_safe
    contact = Contact.find_by_id(raw_params['id'])
    validate_contact_presence(contact)
    validate_contact_ownership(contact)
    @data = ContactSerializer.new(contact, except: :phone_numbers).serializable_hash
  end

  def log_messages(*)
  end

  private

  def validate_contact_presence(contact)
    unless contact
      add_error(:contact_id, "not found by id=#{raw_params['id']}")
      fail(ActiveRecord::Rollback)
    end
  end

  def validate_contact_ownership(contact)
    unless contact.owner_mkey == owner_mkey
      add_error(:contact_id, 'not belongs to owner')
      fail(ActiveRecord::Rollback)
    end
  end
end
