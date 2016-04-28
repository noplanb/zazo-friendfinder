class Api::Contact::Add < Api::BaseHandler
  params_validation id: { type: String }

  def do_safe
    id = raw_params['id']
    contact = ::Contact.find_by_id(id)
    validate_contact_presence(contact, "not found by id=#{id}")
    validate_contact_ownership(contact, "you are not owner of contact id=#{id}")
    instance = ::Contact::Add.new(contact, caller: :api)
    instance.phone_number = raw_params['phone_number']
    @data = instance.do
  end

  private

  def validate_contact_presence(contact, message)
    unless contact
      add_error(:contact_id, message)
      fail(ActiveRecord::Rollback)
    end
  end

  def validate_contact_ownership(contact, message)
    unless contact.owner_mkey == owner_mkey
      add_error(:contact_id, message)
      fail(ActiveRecord::Rollback)
    end
  end
end
