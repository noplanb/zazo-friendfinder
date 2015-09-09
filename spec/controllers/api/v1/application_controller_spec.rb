require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  use_vcr_cassette 'authentication/with_http_digest', api_base_urls
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  controller do
    def index
      render text: 'success'
    end
  end

  describe 'GET #index with digest auth' do
    before do
      authenticate_with_http_digest(user_mkey, user_auth) { get :index }
    end

    it { expect(response).to be_success }
  end

  describe 'GET #index without auth' do
    before { get :index }

    it { expect(response).to have_http_status(:unauthorized) }
  end
end
