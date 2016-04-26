class Contact::ControllerManager::AddContacts < Contact::ControllerManager::BaseHandler
  params_validation contacts_ids: { type: Array }

  def do_safe
    @data = raw_params['contacts_ids'].reduce({}) do |memo, id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:contact_id, "not found by id=#{id}")
        fail(ActiveRecord::Rollback)
      end
      memo[id] = Contact::Add.new(contact, caller: :api).do
    end
  end
end
