# stolen from https://gist.github.com/murbanski/6b971a3edc91b562acaf

module DigestAuthHelpers
  def authenticate_with_http_digest(user, password, &request_trigger)
    request.env['HTTP_AUTHORIZATION'] = encode_credentials(user, password, &request_trigger)
    request_trigger.call
  end

  def encode_credentials(user, password, &request_trigger)
    request_trigger.call
    expect(response).to have_http_status(:unauthorized)

    credentials = decode_credentials(response.headers['WWW-Authenticate'])
    credentials.merge!({ username: user, nc: "00000001", cnonce: "0a4f113b", password_is_ha1: false })
    path_info = request.env['PATH_INFO'].to_s
    credentials.merge!(uri: path_info)
    request.env["ORIGINAL_FULLPATH"] = path_info
    ActionController::HttpAuthentication::Digest.encode_credentials(request.method, credentials, password, credentials[:password_is_ha1])
  end

  def decode_credentials(header)
    ActionController::HttpAuthentication::Digest.decode_credentials(header)
  end
end

RSpec.configure do |config|
  config.include DigestAuthHelpers, type: :controller
end
