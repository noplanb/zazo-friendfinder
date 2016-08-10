require 'rails_helper'

RSpec.describe Api::V1::SuggestionsController, type: :controller,
  vcr: { strip_classname: true, cassette: 'api/authentication' } do
  include_context 'user authentication'

  let(:user) do
    build(:user,
      mkey: '7qdanSEmctZ2jPnYA0a1',
      auth: 'yLPv2hZ4DPRq1wGlQvqm')
  end

  describe 'GET #index' do
    let!(:contact_1) { create(:contact, owner_mkey: user.mkey) }
    let!(:contact_2) { create(:contact, owner_mkey: user.mkey) }

    before do
      authenticate_user { get :index, format: :json }
    end

    it { expect(response).to be_success }
  end

  describe 'POST #recommend' do
    let(:contact) { create(:contact, owner_mkey: build(:user).mkey) }
    let(:params) do
      { recommendations: {
          contact_mkey: build(:user).mkey, to_mkeys: [contact.owner.mkey] } }
    end

    before do
      authenticate_user { post :recommend, params.merge(format: :json) }
    end

    it { expect(response).to be_success }
    it { expect(json_response).to eq('status' => 'success') }
  end
end
