require 'rails_helper'

RSpec.describe Api::V1::SuggestionsController, type: :controller do
  use_vcr_cassette 'authentication/with_http_digest', api_base_urls
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  describe 'POST #create' do
    before do
      authenticate_with_http_digest(user_mkey, user_auth) { get :index, format: :json }
    end

    it { expect(response).to be_success }
  end
end
