class Contact::ControllerManager::AddContacts < Contact::ControllerManager::BaseHandler
  params_validation contacts_ids: { type: Array }

  def do_safe
    raw_params['contacts_ids'].each do |id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:contact_id, "not found by id=#{id}")
        fail(ActiveRecord::Rollback)
      end
      Contact::Add.new(contact).do
    end
  end
end
