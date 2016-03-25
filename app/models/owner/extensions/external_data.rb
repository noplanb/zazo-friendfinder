module Owner::Extensions::ExternalData
  def self.included(base)
    base.class_eval do
      attr_reader :first_name, :last_name
    end
  end

  def fetch_data
    attributes = DataProviderApi.new(user: mkey, attrs: [:first_name, :last_name]).query(:attributes) rescue nil
    @first_name, @last_name = [attributes['first_name'], attributes['last_name']] if attributes
    self
  end

  def full_name
    "#{first_name} #{last_name}".strip if first_name || last_name
  end
end
