class Contact::ControllerManager::RejectContacts < Contact::ControllerManager::Base
  params_validation rejected: { type: Array }

  def do_safe
    raw_params['rejected'].each do |id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:raw_params_id, "contact with id=#{id} is not exist")
        fail(ActiveRecord::Rollback)
      end
      reject_contact(contact)
    end
  end

  def errors
    validation.errors.messages.merge(@errors || {})
  end

  private

  def reject_contact(contact)
    contact.additions ||= {}
    contact.additions['rejected_by_owner'] = true
    contact.save
  end

  def add_error(key, error)
    @errors ||= {}
    @errors[key] ||= []
    @errors[key] << error
  end
end
