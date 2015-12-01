class AdminController < ActionController::Base
  layout 'admin'

  http_basic_authenticate_with name: Figaro.env.http_basic_name,
                               password: Figaro.env.http_basic_password
end
