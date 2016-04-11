require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }
  let(:notification) { FactoryGirl.create(:notification) }
  let(:nkey) { notification.nkey }
  let(:incorrect_nkey) { 'xxxxxxxxxxxx' }

  before do
    authenticate_with_http_digest(user_mkey, user_auth) { post action, id: nkey }
    notification.reload
  end

  describe 'POST #add' do
    let(:action) { :add }

    it { expect(response).to be_success }
    it { expect(notification.status).to eq 'added' }

    context 'when nkey is incorrect' do
      let(:nkey) { incorrect_nkey }

      it { expect(response).to be_unprocessable }
      it { expect(notification.status).to eq 'no_feedback' }
      it { expect(response.body).to eq "{\"status\":\"failure\",\"errors\":{\"nkey\":[\"nkey is incorrect\"]}}" }
      it { expect(response.header['Content-Type']).to include 'application/json'  }
    end
  end

  describe 'POST #ignore' do
    let(:action) { :ignore }

    it { expect(response).to be_success }
    it { expect(notification.status).to eq 'ignored' }
  end


end
