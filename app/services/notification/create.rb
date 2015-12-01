class Notification::Create
  attr_reader :category, :contact

  def initialize(category, contact)
    @category = category.to_s
    @contact  = contact
  end

  def do
    Notification::ALLOWED_KINDS.map do |kind|
      @last_notification = Notification.new params(kind)
      @last_notification.compiled_content = compiled_content
      save ? @last_notification : nil
    end.compact
  end

  private

  def params(kind)
    { kind: kind, category: category, contact: contact, nkey: nkey }
  end

  def nkey
    Digest::SHA256.hexdigest category + contact.owner.mkey + contact.id.to_s
  end

  def compiled_content
    template = Template.new @last_notification
    Template::Render.new(template).content
  end

  def save
    Notification::Save.new(@last_notification).do
  end
end
