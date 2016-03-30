require 'rails_helper'

RSpec.describe Contact::Update::SetZazoInfoByOwner do
  use_vcr_cassette 'contact/set_zazo_id_and_mkey_by_mobile', api_base_urls

  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:mobile) { '+16502453537' }
  let(:email)  { 'admin@google.com' }
  let(:instance) { described_class.new(owner_mkey) }

  let!(:contact_1) { FactoryGirl.create(:contact, owner_mkey: owner_mkey, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)]) }
  let!(:contact_2) { FactoryGirl.create(:contact, owner_mkey: owner_mkey, vectors: [FactoryGirl.create(:vector_email, value: email)]) }

  describe '#do' do
    before do
      instance.do
      contact_1.reload
      contact_2.reload
    end

    context 'existing user' do
      it { expect(contact_1.zazo_id).to eq 1 }
      it { expect(contact_1.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'nonexistent user' do
      use_vcr_cassette 'contact/set_zazo_id_and_mkey_for_nonexistent_user', api_base_urls

      it { expect(contact_2.zazo_id).to be_nil }
      it { expect(contact_2.zazo_mkey).to be_nil }
    end
  end
end
