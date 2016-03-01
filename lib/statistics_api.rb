class StatisticsApi < BaseApi
  version     1
  base_uri    Figaro.env.statistics_api_base_url
  digest_auth AppConfig.app_name_key, Figaro.env.statistics_api_token

  mapper attributes: { action: :get, prefix: 'fetch/attributes' },
         push_user:  { action: :get, prefix: 'fetch/push_user' },
         users: { action: :get, prefix: 'fetch/users' }
end
