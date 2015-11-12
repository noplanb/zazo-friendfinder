class TemplateData
  attr_reader :contact

  class ContactData
    attr_reader :name

    def initialize(contact)
      @name = contact.display_name
    end
  end

  def initialize(notification, contact = nil)
    @notification = notification
    @contact = ContactData.new contact || notification.contact
  end

  def add_link
    action_link :add
  end

  def ignore_link
    action_link :ignore
  end

  def unsubscribe_link
    action_link :unsubscribe
  end

  def bind
    binding
  end

  private

  def action_link(type)
    "ff.zazoapp.com/w/#{@notification.nkey}/#{type}"
  end
end
