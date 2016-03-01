require 'rails_helper'

RSpec.describe Api::V1::SuggestionsController, type: :controller do
  use_vcr_cassette 'authentication/with_http_digest', api_base_urls
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

  describe 'POST #reject' do
    let(:contact_1) { FactoryGirl.create :contact, owner_mkey: user_mkey }
    let(:contact_2) { FactoryGirl.create :contact, owner_mkey: user_mkey }
    let(:params) do
      { rejected: [contact_1.id, contact_2.id] }
    end
    before do
      authenticate_with_http_digest(user_mkey, user_auth) { post :reject, params.merge({format: :json}) }
    end

    it { expect(response).to be_success }
  end

  describe 'POST #recommend' do
    let(:contact) { FactoryGirl.create :contact, owner_mkey: FactoryGirl.build(:user).mkey }
    let(:params) do
      { recommendations: {
          contact_mkey: FactoryGirl.build(:user).mkey,
          to_mkeys: [contact.owner.mkey] } }
    end
    before do
      authenticate_with_http_digest(user_mkey, user_auth) { post :recommend, params.merge({format: :json}) }
    end

    it { expect(response).to be_success }
  end
end
