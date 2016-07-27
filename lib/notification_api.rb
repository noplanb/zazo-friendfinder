class NotificationApi < Zazo::Tool::ServiceApiWrapper
  version     1
  base_uri    Figaro.env.notification_api_base_url
  digest_auth AppConfig.app_name_key, Figaro.env.notification_api_token

  mapper email:   { action: :post, prefix: 'notifications/email' },
         mobile:  { action: :post, prefix: 'notifications/mobile' },
         default: { action: :get,  prefix: '' }
end
