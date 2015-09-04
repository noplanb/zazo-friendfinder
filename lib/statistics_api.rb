class StatisticsApi < BaseApi
  version  1
  base_uri Figaro.env.statistics_api_base_url

  mapper attributes: { action: :get,  prefix: 'fetch/attributes' }
end
