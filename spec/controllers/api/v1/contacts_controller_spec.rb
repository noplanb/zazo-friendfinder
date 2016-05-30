require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  describe 'POST #create' do
    let(:params) { { 'contacts' => contacts }.merge(format: :json) }
    let(:subject) { Owner.new(user_mkey).contacts }

    before do
      ResqueSpec.reset!
      authenticate_with_http_digest(user_mkey, user_auth) { post :create, params }
    end

    context 'when contacts have valid scheme' do
      let(:contacts) do
        [
          {
            'display_name' => 'Sani Elfishawy',
            'vectors'      => [
              { 'name'  => 'email',
                'value' => 'elfishawy.sani@gmail.com' },
              { 'name'  => 'mobile',
                'value' => '+16502453537',
                'additions' => { 'sms_messages_sent' => 15 } }
            ],
            'additions'    => { 'marked_as_favorite' => true }
          }
        ]
      end

      it { expect(response).to be_success }
      it { expect(ResqueWorker::ImportContacts).to have_queued(user_mkey, params['contacts']).in(:add_contacts) }
    end

    context 'when contacts have invalid scheme' do
      let(:contacts) do
        [
          {
            'display_name' => 'Ivan Kornilov',
          }, {
            'display_name' => 'Sani Elfishawy',
            'vectors'      => [
              { 'name'  => 'email',
                'value' => 'elfishawy.sani@gmail.com' }
            ]
          }
        ]
      end

      it { expect(response).to be_unprocessable }
      it { expect(ResqueWorker::ImportContacts).to_not have_queued(user_mkey, params['contacts']).in(:add_contacts) }
      it do
        expect(json_response).to eq 'status' => 'failure',
                                    'errors' => { 'invalid_contacts' => [contacts.first] }
      end
    end
  end

  describe 'POST #ignore' do
    let(:contact) { FactoryGirl.create(:contact, owner_mkey: user_mkey) }
    let(:params) { { id: contact.id.to_s } }

    before do
      authenticate_with_http_digest(user_mkey, user_auth) { post :ignore, params.merge(format: :json) }
    end

    it { expect(response).to be_success }
  end
end
