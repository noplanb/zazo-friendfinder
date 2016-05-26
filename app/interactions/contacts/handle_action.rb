class Contacts::HandleAction < ActiveInteraction::Base
  string :action
  symbol :caller
  object :contact
  string :phone_number, default: ''

  validates :action, inclusion: { in: %w(add ignore),
                                  message: '%{value} is not a allowed action' }

  def execute
    if action == 'add'
      service = Contact::Add.new(contact, caller: caller)
      service.phone_number = phone_number
      service.do
    else
      Contact::Ignore.new(contact, caller: caller).do
    end
  end
end
