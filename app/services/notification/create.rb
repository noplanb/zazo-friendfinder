class Notification::Create
  DEFAULT_OPTIONS = { email: true, mobile: true }

  attr_reader :category, :contact, :options

  def initialize(category, contact, options = {})
    @category = category.to_s
    @contact = contact
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def do
    allowed_kinds.map do |kind|
      @last_notification = Notification.new(params(kind))
      save ? @last_notification : nil
    end.compact
  end

  private

  def allowed_kinds
    Notification::ALLOWED_KINDS.select { |kind| options[kind.to_sym] }
  end

  def params(kind)
    { kind: kind, category: category, contact: contact, nkey: nkey }
  end

  def nkey
    Digest::SHA256.hexdigest(category + contact.owner.mkey + contact.id.to_s)
  end

  def save
    Notification::Save.new(@last_notification).do
  end
end
