require 'rails_helper'

RSpec.describe Owner, type: :model do
  let!(:contact_1) { FactoryGirl.create(:contact, owner_mkey: mkey, total_score: 4) }
  let!(:contact_2) { FactoryGirl.create(:contact, owner_mkey: mkey, total_score: 6) }
  let(:mkey) { 'xxxxxxxxxxxx' }
  let(:instance) { described_class.new(mkey) }

  describe '#full_name' do
    let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }
    subject { instance.fetch_data.full_name }

    it { is_expected.to eq 'Sani Elfishawy' }
  end

  describe '#contacts' do
    subject { instance.contacts }
    it { is_expected.to eq [contact_2, contact_1] }
  end

  describe '#not_proposed_contacts' do
    subject { instance.contacts.not_proposed }
    before do
      FactoryGirl.create(:notification, contact: contact_2)
    end

    it { is_expected.to eq [contact_1] }
  end
end
