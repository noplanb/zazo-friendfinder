class Contact::AddContacts
  attr_reader :current_user, :params, :validation

  class Validation
    include ActiveModel::Validations

    def initialize(params)
      @params = params
    end
  end

  def initialize(current_user, params)
    @current_user = current_user
    @params       = params
    @validation   = Validation.new(params)
  end

  def do
    validation.valid?
  end
end
