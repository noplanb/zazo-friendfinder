require 'rails_helper'

RSpec.describe Contact::SetZazoInfoByOwner do
  use_vcr_cassette 'contact/set_zazo_id_and_mkey_by_mobile', api_base_urls
  use_vcr_cassette 'contact/set_zazo_id_and_mkey_for_nonexistent_user', api_base_urls

  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:mobile) { '+16502453537' }
  let(:email)  { 'admin@google.com' }
  let!(:contact_1) { FactoryGirl.create :contact, owner_mkey: owner_mkey, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)] }
  let!(:contact_2) { FactoryGirl.create :contact, owner_mkey: owner_mkey, vectors: [FactoryGirl.create(:vector_email,  value: email)] }
  let(:instance) { described_class.new owner_mkey }

  describe '#do' do
    before { instance.do; [contact_1, contact_2].each &:reload }

    it { expect(contact_1.zazo_id).to eq 1 }
    it { expect(contact_1.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }

    it { expect(contact_2.zazo_id).to be_nil }
    it { expect(contact_2.zazo_mkey).to be_nil }
  end
end
