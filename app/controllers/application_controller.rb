class ApplicationController < ActionController::Base
  include Authentication
  include HandleWithManager
end
