require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller,
  vcr: { strip_classname: true, cassette: 'api/authentication' } do
  include_context 'user authentication'

  let(:user) do
    build(:user,
      mkey: '7qdanSEmctZ2jPnYA0a1',
      auth: 'yLPv2hZ4DPRq1wGlQvqm')
  end

  let(:vector) { FactoryGirl.create(:vector_mobile, value: '+16502453537') }
  let(:contact) do
    FactoryGirl.create(:contact,
      first_name: 'David',
      last_name: 'Miller',
      owner_mkey: 'GBAHb0482YxlJ0kYwbIS',
      vectors: [vector])
  end
  let(:notification) { FactoryGirl.create(:notification, contact: contact) }
  let(:nkey) { notification.nkey }
  let(:incorrect_nkey) { 'xxxxxxxxxxxx' }

  before do
    authenticate_user { send(*(action + [{ id: nkey }])) }
    notification.reload
  end

  describe 'GET #show' do
    let(:action) { [:get, :show] }

    it { expect(response).to be_success }
    it { expect(json_response['data']['contact']).to be_kind_of(Hash) }
  end

  describe 'POST #add', vcr: { cassette: 'add' } do
    let(:action) { [:post, :add] }

    it { expect(response).to be_success }
    it { expect(notification.status).to eq('added') }
    it do
      expected = {
        'status' => 'success',
        'data' => {
          'id' => '32',
          'mkey' => 'tq1Bk0hUprbrTHfIKhAE',
          'first_name' => 'David',
          'last_name' => 'Miller',
          'mobile_number' => '+16502453537',
          'device_platform' => nil,
          'emails' => [],
          'has_app' => 'false',
          'ckey' => '2_32_xrE5jKBoeGE2FGrSpbDV',
          'cid' => '2',
          'connection_created_on' => '2016-08-09T10:42:38Z',
          'connection_creator_mkey' => 'GBAHb0482YxlJ0kYwbIS',
          'connection_status' => 'established',
          'status' => 'added' } }
      expect(json_response).to eq(expected)
    end

    context 'when nkey is incorrect' do
      let(:nkey) { incorrect_nkey }

      it { expect(response).to be_unprocessable }
      it { expect(notification.status).to eq('no_feedback') }
      it do
        expected = {
          'status' => 'failure',
          'errors' => ['Nkey nkey is incorrect'] }
        expect(json_response).to eq(expected)
      end
    end
  end

  describe 'POST #ignore' do
    let(:action) { [:post, :ignore] }

    it { expect(response).to be_success }
    it { expect(notification.status).to eq('ignored') }
  end
end
