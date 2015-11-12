class TemplateDecorator < Draper::Decorator
  delegate_all

  def preview
    Template::Compiler.new(self).preview
  end
end
