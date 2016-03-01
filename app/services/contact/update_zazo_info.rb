class Contact::UpdateZazoInfo
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    if contact.zazo_mkey && !attributes.empty?
      contact.tap do |c|
        c.zazo_id    = attributes['id']
        c.first_name = attributes['first_name']
        c.last_name  = attributes['last_name']
        c.save
      end
    end
    contact
  end

  private

  def attributes
    @attributes ||= DataProviderApi.new(user: contact.zazo_mkey, attrs: [:id, :first_name, :last_name]).query :attributes
  rescue Faraday::ClientError
    {}
  end
end
