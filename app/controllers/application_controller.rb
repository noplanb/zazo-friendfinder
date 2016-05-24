class ApplicationController < ActionController::Base
  force_ssl if %w(production staging).include?(Rails.env)
end
