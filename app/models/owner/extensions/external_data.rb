module Owner::Extensions::ExternalData
  def self.included(base)
    base.class_eval do
      attr_reader :auth, :first_name, :last_name, :friends
    end
  end

  def fetch_data
    unless @external_data
      attrs = [:auth, :first_name, :last_name, :friends]
      default_attributes = { 'friends' => [] }
      @external_data = DataProviderApi.new(user: mkey, attrs: attrs).query(:attributes) rescue default_attributes
      attrs.each { |attr| instance_variable_set(:"@#{attr}", @external_data[attr.to_s]) }
    end
    self
  end

  def full_name
    "#{first_name} #{last_name}".strip if first_name || last_name
  end
end
