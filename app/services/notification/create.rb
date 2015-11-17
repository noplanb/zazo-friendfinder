class Notification::Create
  attr_reader :category, :contact

  def initialize(category, contact)
    @category = category.to_s
    @contact  = contact
  end

  def do
    Template::ALLOWED_KINDS.map do |kind|
      notification = Notification.new params
      set_compiled_content notification, kind
      save(notification) ? notification : nil
    end.compact
  end

  private

  def params
    { category: category, contact: contact, nkey: nkey }
  end

  def nkey
    Digest::SHA256.hexdigest category + contact.owner + contact.id.to_s
  end

  def save(notification)
    unless notification.save
      WriteLog.info self, "notification was not saved with errors: #{notification.errors.messages}, inspected: #{notification.inspect}", rollbar: :error
      return false
    end; true
  end

  def set_compiled_content(notification, kind)
    template = Template.by_kind_category kind, category
    if template
      compiler = Template::Compiler.new template
      template_data = TemplateData.new notification
      notification.template = template
      notification.compiled_content = compiler.compile(template_data).content
    else
      WriteLog.info self, "template by pair (#{kind},#{category}) not found", rollbar: :error
    end
  end
end
