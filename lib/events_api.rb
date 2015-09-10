class EventsApi < BaseApi
  version  1
  base_uri Figaro.env.events_api_base_url

  mapper metric:  { action: :post, prefix: 'metrics' },
         default: { action: :get,  prefix: '' }
end
