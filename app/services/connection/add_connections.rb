class Connection::AddConnections
  attr_reader :params, :validation

  class Validation
    include ActiveModel::Validations

    def initialize(params)
      @params = params
    end
  end

  def initialize(params)
    @params     = params
    @validation = Validation.new(params)
  end

  def create
    validation.valid?
  end
end
