class ApiController < ActionController::Base
  include Authentication
  include Authorization
  include HandleWithManager
end
