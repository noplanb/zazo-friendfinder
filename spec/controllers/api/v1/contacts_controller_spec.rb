require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  use_vcr_cassette 'authentication/with_http_digest', api_base_urls
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  describe 'POST #create' do
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
    let(:params) { { 'contacts' => contacts }.merge(format: :json) }
    let(:subject) { Owner.new(user_mkey).contacts }

    before do
      ResqueSpec.reset!
      authenticate_with_http_digest(user_mkey, user_auth) { post :create, params }
    end

    it { expect(response).to be_success }
    it { expect(Contact::AddContactsWorker).to have_queued(user_mkey, params['contacts']).in(:add_contacts) }
  end
end
