class Contact::AddContacts
  attr_reader :current_user, :params, :validator

  def initialize(current_user, params)
    @current_user = current_user
    @params       = params
    @validator    = AddContactsValidator.new(params)
  end

  def do
    validator.valid?
  end
end
