module BasicAuthHelpers
  def authenticate_with_http_basic
    username = Figaro.env.http_basic_username
    password = Figaro.env.http_basic_password
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
  end
end

RSpec.configure do |config|
  config.include BasicAuthHelpers, type: :controller
  config.before(authenticate_with_http_basic: true) do
    authenticate_with_http_basic
  end
end
