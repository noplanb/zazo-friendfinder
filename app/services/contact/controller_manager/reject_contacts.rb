class Contact::ControllerManager::RejectContacts < Contact::ControllerManager::Base
  params_validation rejected: { type: Array }

  def do_safe
    raw_params['rejected'].each do |id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:raw_params_id, "contact with id=#{id} is not exist")
        fail(ActiveRecord::Rollback)
      end
      Contact::Ignore.new(contact).do
    end
  end
end
