class Notification::Create
  attr_reader :category, :contact

  def initialize(category, contact)
    @category = category
    @contact  = contact
  end

  def do
    notification = Notification.new
  end

  private

  def parameters
    {  }
  end
end
