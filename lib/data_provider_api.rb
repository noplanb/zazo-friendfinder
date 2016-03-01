class DataProviderApi < BaseApi
  version  1
  base_uri Figaro.env.dataprovider_api_base_url
  digest_auth AppConfig.app_name_key, Figaro.env.dataprovider_api_token

  mapper filter:      { action: :get,  prefix: 'fetch/users/filters' },
         filter_post: { action: :post, prefix: 'fetch/users/filters' },
         query:       { action: :get,  prefix: 'fetch/users/queries' },
         query_post:  { action: :post, prefix: 'fetch/users/queries' },
         metric:      { action: :post, prefix: 'fetch/users/metrics' },
         default:     { action: :get,  prefix: '' }
end
