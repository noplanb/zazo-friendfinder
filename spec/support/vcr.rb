def api_base_urls
  { dataprovider_api_base_url: Figaro.env.dataprovider_api_base_url,
    notification_api_base_url: Figaro.env.notification_api_base_url,
    mainserver_api_base_url:   Figaro.env.mainserver_api_base_url }
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.before_record do |i|
    i.response.headers.delete('Set-Cookie')
    i.request.headers.delete('Authorization')
  end

  c.after_http_request(:recordable?) do |req, _|
    api_base_urls.each { |k, v| req.uri.gsub!(v, "<%= #{k} %>") }
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    options = example.metadata[:vcr]
    if !options
      example.call
    elsif options[:record] == :skip
      VCR.turned_off(&example)
    else
      cassette = if options[:strip_classname]
        options[:cassette]
      else
        klass = example.metadata[:described_class]
        "#{klass.to_s.underscore}/#{options[:cassette]}"
      end
      example.metadata[:vcr] = { cassette_name: cassette, erb: api_base_urls }
      example.call
    end
  end
end
