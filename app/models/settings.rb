class Settings < RailsSettings::Base
  source Rails.root.join('config/app_settings.yml')
  namespace Rails.env
end
