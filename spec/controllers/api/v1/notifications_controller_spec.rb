require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  let(:user_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:user_auth) { 'O4VXCozKuyQNjnWPh400' }

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
    authenticate_with_http_digest(user_mkey, user_auth) { send(*(action + [{ id: nkey }])) }
    notification.reload
  end

  describe 'GET #show' do
    let(:action) { [:get, :show] }

    it { expect(response).to be_success }
    it { expect(json_response['data']['contact']).to be_kind_of(Hash) }
  end

  describe 'POST #add' do
    let(:action) { [:post, :add] }

    it { expect(response).to be_success }
    it { expect(notification.status).to eq('added') }
    it do
      expected = {
        'status' => 'success',
        'data' => {
          'id' => '20',
          'mkey' => 'SvFhibPZhIFUJsB2iYl8',
          'first_name' => 'Charley',
          'last_name' => 'Bashirian',
          'mobile_number' => '+16502453537',
          'device_platform' => nil,
          'emails'=>[],
          'has_app' => 'false',
          'ckey' => '2_20_0mkxC2UShfdX2RuA5ly4',
          'cid' => '19',
          'connection_created_on' => '2016-04-25T17:36:13Z',
          'connection_creator_mkey' => 'GBAHb0482YxlJ0kYwbIS',
          'connection_status' => 'established',
          'status' => 'added'
        }
      }
      expect(json_response).to eq(expected)
    end

    context 'when nkey is incorrect' do
      let(:nkey) { incorrect_nkey }

      it { expect(response).to be_unprocessable }
      it { expect(notification.status).to eq 'no_feedback' }
      it do
        expected = {
          'status' => 'failure',
          'errors' => { 'nkey' => ['nkey is incorrect'] }
        }
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
