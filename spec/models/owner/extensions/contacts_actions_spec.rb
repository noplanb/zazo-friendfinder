require 'rails_helper'

RSpec.describe Owner::Extensions::ContactsActions, type: :model do
  use_vcr_cassette 'owner/extensions/find_contact_and_update_zazo_info', api_base_urls

  let(:mobile) { '+16502453537' }
  let(:email) { 'admin@google.com' }
  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:instance) { Owner.new(owner_mkey).contacts_actions }

  let!(:contact_1) do
    FactoryGirl.create(:contact, owner_mkey: owner_mkey,
                       vectors: [FactoryGirl.create(:vector_mobile, value: mobile)])
  end
  let!(:contact_2) do
    FactoryGirl.create(:contact, owner_mkey: owner_mkey,
                       vectors: [FactoryGirl.create(:vector_email, value: email)])
  end

  describe '#find_contact_and_update_zazo_info' do
    subject { instance.find_contact_and_update_zazo_info }

    before do
      subject
      contact_1.reload
      contact_2.reload
    end

    context 'existing user' do
      it { expect(contact_1.zazo_id).to eq 1 }
      it { expect(contact_1.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'nonexistent user' do
      it { expect(contact_2.zazo_id).to be_nil }
      it { expect(contact_2.zazo_mkey).to be_nil }
    end
  end
end
