class Notification::Data
  include ActiveModel::Validations

  attr_reader :object

  def initialize(object)
    @object = object
    set_attributes
  end

  def get
  end

  protected

  def set_attributes
  end
end
