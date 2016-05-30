require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }
  let(:additions) { nil }
  let(:owner) { Owner.new(user_mkey) }

  before do
    additions &&
      FactoryGirl.create(:owner_additions, { mkey: user_mkey }.merge(additions))
    authenticate_with_http_digest(user_mkey, user_auth) { send(*action) }
  end

  describe 'GET #index' do
    let(:action) { [:get, :index] }

    context 'when already subscribed' do
      it { expect(response).to be_success }
      it do
        expected = {
          'status' => 'success',
          'data' => { 'status' => 'subscribed' }
        }
        expect(json_response).to eq(expected)
      end
    end

    context 'when already unsubscribed' do
      let(:additions) { { unsubscribed: true } }

      it { expect(response).to be_success }
      it do
        expected = {
          'status' => 'success',
          'data' => { 'status' => 'unsubscribed' }
        }
        expect(json_response).to eq(expected)
      end
    end
  end

  describe 'POST #unsubscribe' do
    let(:action) { [:post, :unsubscribe] }

    it { expect(response).to be_success }
    it { expect(owner.unsubscribed?).to be(true) }
  end

  describe 'POST #subscribe' do
    let(:action) { [:post, :subscribe] }

    it { expect(response).to be_success }
    it { expect(owner.unsubscribed?).to be(false) }
  end
end
