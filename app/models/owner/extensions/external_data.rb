module Owner::Extensions::ExternalData
  def self.included(base)
    base.class_eval do
      attr_reader :first_name, :last_name, :friends
    end
  end

  def fetch_data
    attrs = [:first_name, :last_name, :friends]
    default_attributes = { 'friends' => [] }
    attributes = DataProviderApi.new(user: mkey, attrs: attrs).query(:attributes) rescue default_attributes
    attrs.each { |attr| instance_variable_set(:"@#{attr}", attributes[attr.to_s]) }
    self
  end

  def full_name
    "#{first_name} #{last_name}".strip if first_name || last_name
  end
end
