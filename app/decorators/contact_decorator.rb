class ContactDecorator < Draper::Decorator
  delegate_all

  def owner
    Owner.new self.owner
  end
end
