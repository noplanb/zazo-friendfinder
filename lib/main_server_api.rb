class MainServerApi < Zazo::Tool::ServiceApiWrapper
  base_uri Figaro.env.mainserver_api_base_url

  mapper invite: { action: :get,  prefix: 'invitation/invite' }
end
