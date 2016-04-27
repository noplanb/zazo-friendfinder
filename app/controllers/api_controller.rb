class ApiController < ActionController::Base
  include Authorization
  include HandleWithManager
end
