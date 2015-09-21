require 'rails_helper'

RSpec.describe Api::V1::ContactsController, type: :controller do
  use_vcr_cassette 'authentication/with_http_digest', api_base_urls
  let(:user_mkey) { '7qdanSEmctZ2jPnYA0a1' }
  let(:user_auth) { 'yLPv2hZ4DPRq1wGlQvqm' }

  describe 'POST #create' do
    let(:contacts) do
      vectors = [
        { 'name'  => 'email',
          'value' => 'elfishawy.sani@gmail.com' },
        { 'name'  => 'mobile',
          'value' => '+16502453537',
          'additions' => { 'sms_messages_sent' => 15 } }
      ]
      [{ 'display_name' => 'Sani Elfishawy',
         'vectors'      => vectors,
         'additions'    => { 'marked_as_favorite' => true } }]
    end
    let(:params) { { 'contacts' => contacts }.merge(format: :json) }
    let(:subject) { Contact.by_owner user_mkey }

    before do
      ResqueSpec.reset!
      authenticate_with_http_digest(user_mkey, user_auth) { post :create, params }
    end

    it { expect(response).to be_success }
    it { expect(subject.size).to eq 1 }
    it { expect(UpdateNewContactsByOwnerWorker).to have_queued(user_mkey).in(:update_contacts) }
  end
end
