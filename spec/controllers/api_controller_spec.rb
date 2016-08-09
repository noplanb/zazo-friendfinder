require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  include_context 'user authentication'

  let(:user) do
    build(:user,
      mkey: '7qdanSEmctZ2jPnYA0a1',
      auth: 'yLPv2hZ4DPRq1wGlQvqm')
  end

  controller do
    def index
      render text: 'success'
    end
  end

  describe 'GET #index' do
    context 'with authentication',
      vcr: { strip_classname: true, cassette: 'api/authentication' } do
      it do
        authenticate_user { get :index }
        expect(response).to be_success
      end
    end

    context 'without authentication' do
      it do
        get :index
        expect(response).to be_unauthorized
      end
    end
  end
end
