require 'rails_helper'

RSpec.describe Api::V1::ConnectionsController, type: :controller do
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { '7qdanSEmctZ2jPnYA0a1' }

  describe 'POST #create' do
    use_vcr_cassette 'authentication/with_http_digest', api_base_urls

    before do
      authenticate_with_http_digest(user_mkey, user_auth) do
        post :create, format: :json
      end
    end

    it { expect(response).to be_success }
  end
end
