class Api::Contact::Ignore < Api::BaseHandler
  params_validation contacts_ids: { type: Array }

  def do_safe
    raw_params['contacts_ids'].each do |id|
      contact = Contact.find_by_id(id)
      unless contact
        add_error(:contact_id, "not found by id=#{id}")
        fail(ActiveRecord::Rollback)
      end
      Contact::Ignore.new(contact, caller: :api).do
    end
  end
end
