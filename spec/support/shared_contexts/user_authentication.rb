RSpec.shared_context 'user authentication' do
  def authenticate_user
    authenticate_with_http_digest(user.mkey, user.auth) { yield }
  end
end
