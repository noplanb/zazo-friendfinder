class WebClient::TrackEmailsController < ActionController::Base
  def index
    WebClient::TrackEmail.new(params).do
    send_file(Rails.root.join('public', 'email', 'track_email.gif'), type: 'image/gif', disposition: 'inline')
  end
end
