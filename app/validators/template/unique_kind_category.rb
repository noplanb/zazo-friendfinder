class Template::UniqueKindCategory < ActiveModel::Validator
  def validate(template)
    message = "template with pair (#{template.kind},#{template.category}) already exist"
    if kind_category_exist?(template)
      template.errors.add :kind, message
      template.errors.add :category, message
    end
  end

  private

  def kind_category_exist?(template)
    !Template.where(kind: template.kind, category: template.category).empty?
  end
end
