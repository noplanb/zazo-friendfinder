class NotificationDecorator < Draper::Decorator
  delegate_all

  def kind
    template.try :kind
  end

  def has_template?
    !template.nil?
  end
end
