class Contact::ControllerManager::AddContacts < Contact::ControllerManager::Base
  params_validation added: { type: Array }

  def do_safe
    raw_params['added'].each do |id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:raw_params_id, "contact with id=#{id} is not exist")
        fail(ActiveRecord::Rollback)
      end
      Contact::Add.new(contact).do
    end
  end
end
