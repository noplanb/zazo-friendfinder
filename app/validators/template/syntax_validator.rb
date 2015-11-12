class Template::SyntaxValidator < ActiveModel::Validator
  def validate(record)
    status, error = Template::Compiler.new(model(record)).validate
    record.errors.add(:content, error) unless status
  end

  private

  def model(record)
    Template.new content: record.content
  end
end
