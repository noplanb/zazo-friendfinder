class Template::UniqueKindCategory < ActiveModel::Validator
  def validate(template)
    add_errors template if kind_category_exist? template
  end

  private

  def kind_category_exist?(template)
    scope = Template.where kind: template.kind, category: template.category
    scope = scope.where.not id: template.id unless template.new_record?
    !scope.empty?
  end

  def add_errors(template)
    message = "template with pair (#{template.kind},#{template.category}) already exist"
    template.errors.add :kind, message
    template.errors.add :category, message
  end
end
