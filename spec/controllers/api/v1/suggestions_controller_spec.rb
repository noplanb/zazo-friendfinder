require 'rails_helper'

RSpec.describe Api::V1::SuggestionsController, type: :controller do
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  describe 'GET #index' do
    let!(:contact_1) { FactoryGirl.create :contact, owner_mkey: user_mkey }
    let!(:contact_2) { FactoryGirl.create :contact, owner_mkey: user_mkey }
    before do
      authenticate_with_http_digest(user_mkey, user_auth) { get :index, format: :json }
    end

    it { expect(response).to be_success }
  end

  describe 'POST #recommend' do
    let(:contact) { FactoryGirl.create(:contact, owner_mkey: FactoryGirl.build(:user).mkey) }
    let(:params) do
      { recommendations: { contact_mkey: FactoryGirl.build(:user).mkey, to_mkeys: [contact.owner.mkey] } }
    end

    before do
      authenticate_with_http_digest(user_mkey, user_auth) { post :recommend, params.merge({format: :json}) }
    end

    it { expect(response).to be_success }
  end
end
