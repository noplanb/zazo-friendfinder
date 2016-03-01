class ApiController < ActionController::Base
  include Authentication
  include HandleWithManager
end
