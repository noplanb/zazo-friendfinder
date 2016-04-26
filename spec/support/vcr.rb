RSpec.configure do |config|
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').underscore.gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      VCR.use_cassette(name, options.merge(erb: api_base_urls), &example)
    end
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

def api_base_urls
  { dataprovider_api_base_url: Figaro.env.dataprovider_api_base_url,
    notification_api_base_url: Figaro.env.notification_api_base_url,
    mainserver_api_base_url:   Figaro.env.mainserver_api_base_url }
end
