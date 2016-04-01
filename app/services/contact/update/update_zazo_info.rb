class Contact::Update::UpdateZazoInfo
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def do
    if contact.zazo_mkey
      contact.update_attributes(new_attrs) unless attributes.empty?
    else
      contact.update_attributes(additions: new_additions)
    end
    contact
  end

  private

  def new_attrs
    { zazo_id:    attributes['id'],
      first_name: attributes['first_name'],
      last_name:  attributes['last_name'],
      additions:  new_additions }
  end

  def new_additions
    (contact.additions || {}).merge('marked_as_friend' => contact_is_friend?)
  end

  def contact_is_friend?
    !!attributes['friends'] && attributes['friends'].include?(contact.owner_mkey)
  end

  def attributes
    return @attributes if @attributes
    return {} unless contact.zazo_mkey
    api_params = { user: contact.zazo_mkey, attrs: [:id, :first_name, :last_name, :friends] }
    @attributes = DataProviderApi.new(api_params).query(:attributes)
  rescue Faraday::ClientError
    {}
  end
end
