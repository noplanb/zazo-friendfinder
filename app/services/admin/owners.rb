class Admin::Owners
  attr_reader :owner

  def initialize(owner)
    @owner = owner.kind_of?(String) ? Owner.new(owner) : owner
  end
end
