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

  def validate(key)
    compile preview_data
    send key
    return true
  rescue => e
    return false, e.message
  end

  def compile(template_data)
    @data = template_data.bind
  end

  private

  def preview_data
    TemplateData::Preview.new add_link: 'ff.zazoapp.com/w/3c18885dbd804b4c38d35681985fa377/add',
                              ignore_link: 'ff.zazoapp.com/w/3c18885dbd804b4c38d35681985fa377/ignore',
                              unsubscribe_link: 'ff.zazoapp.com/w/3c18885dbd804b4c38d35681985fa377/unsubscribe',
                              contact: Hashie::Mash.new(name:'Syd Barrett')
  end
end
