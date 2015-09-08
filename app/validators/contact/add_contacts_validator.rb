class Contact::AddContactsValidator
  include ActiveModel::Validations

  def initialize(params)
    @params = params
  end
end
