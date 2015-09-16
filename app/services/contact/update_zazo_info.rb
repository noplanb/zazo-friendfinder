class Contact::UpdateZazoInfo
  include PerformAsync
  allow_async :do

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
    @attributes ||= StatisticsApi.new(user: contact.zazo_mkey, attrs: [:id, :first_name, :last_name]).attributes
  rescue Faraday::ClientError
    Hash.new
  end
end
