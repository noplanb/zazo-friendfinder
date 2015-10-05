class Score::Criteria::Base
  def self.ratio
    1
  end

  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def save
    instance = Score.new({
      name: name,
      contact: contact,
      value: calculate_with_ratio
    })
    instance.save && update_contact
    instance
  end

  def calculate
    0
  end

  def calculate_with_ratio
    (self.class.ratio * calculate).to_i
  end

  protected

  def update_contact
    # redefine this in child
  end

  def name
    self.class.name.split('::').last.underscore
  end
end
