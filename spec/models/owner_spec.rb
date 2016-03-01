require 'rails_helper'

RSpec.describe Owner, type: :model do
  let(:mkey) { 'xxxxxxxxxxxx' }
  let!(:contact_1) { FactoryGirl.create :contact, owner_mkey: mkey, total_score: 4 }
  let!(:contact_2) { FactoryGirl.create :contact, owner_mkey: mkey, total_score: 6 }
  let(:instance) { described_class.new mkey }

  describe '#full_name' do
    let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }
    subject { instance.full_name }

    before do
      VCR.use_cassette('owner/fetch_data/attributes_by_7qdanSEmctZ2jPnYA0a1', api_base_urls) { instance.fetch_data }
    end

    it { is_expected.to eq 'Sani ElFishawy' }
  end

  describe '#contacts' do
    subject { instance.contacts }
    it { is_expected.to eq [contact_2, contact_1] }
  end

  describe '#not_proposed_contacts' do
    subject { instance.not_proposed_contacts }
    before do
      FactoryGirl.create :notification, contact: contact_2
    end

    it { is_expected.to eq [contact_1] }
  end

  describe '#unsubscribed?' do
    subject { instance.unsubscribed? }

    context 'when unsubscribed' do
      before do
        FactoryGirl.create :notification, contact: contact_1, status: 'added'
        FactoryGirl.create :notification, contact: contact_2, status: 'unsubscribed'
      end

      it { is_expected.to be true }
    end

    context 'when not unsubscribed' do
      before do
        FactoryGirl.create :notification, contact: contact_1, status: 'ignored'
        FactoryGirl.create :notification, contact: contact_2, status: 'added'
      end

      it { is_expected.to be false }
    end
  end
end
