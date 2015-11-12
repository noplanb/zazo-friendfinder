class Template::Compiler
  attr_reader :template

  def initialize(template)
    @template = template
  end

  def content
    ERB.new(template.content).result(@data).squish
  end

  def preview
    compile preview_data
    content
  end

  def validate
    compile preview_data
    content
    return true
  rescue => e
    return false, e.message
  end

  def compile(template_data)
    @data = template_data.bind
  end

  private

  def preview_data
    notification = Notification.new nkey: '3c18885dbd804b4c38d35681985fa377'
    contact      = Contact.new display_name: 'Syd Barrett'
    TemplateData.new notification, contact
  end
end
