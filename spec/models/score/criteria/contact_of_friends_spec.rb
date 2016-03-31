require 'rails_helper'

RSpec.describe Score::Criteria::ContactOfFriends do
  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:friend_1) { '0DAQEVtmNKQiW6aoQrvo' }
  let(:friend_2) { '7qdanSEmctZ2jPnYA0a1' }

  let(:contact) { FactoryGirl.create(:contact, owner_mkey: owner_mkey, vectors: vectors) }
  let(:instance) { described_class.new contact }

  let(:email) { 'elfishawy.sani@gmail.com' }
  let(:mobile) { '+16502453537' }
  let(:vectors) do
    [ FactoryGirl.create(:vector_email, value: email),
      FactoryGirl.create(:vector_mobile, value: mobile) ]
  end

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'by two friends overlap' do
      before do
        FactoryGirl.create(:contact, owner_mkey: friend_1, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)])
        FactoryGirl.create(:contact, owner_mkey: friend_2, vectors: [FactoryGirl.create(:vector_email, value: email)])
        FactoryGirl.create(:contact, vectors: [FactoryGirl.create(:vector_email, value: email)])
      end

      it { is_expected.to eq 16 }
    end

    context 'by one friend overlap' do
      before do
        FactoryGirl.create(:contact, owner_mkey: friend_1, vectors: [FactoryGirl.create(:vector_mobile, value: mobile), FactoryGirl.create(:vector_email, value: email)])
        FactoryGirl.create(:contact, vectors: [FactoryGirl.create(:vector_email, value: email)])
      end

      it { is_expected.to eq 8 }
    end

    context 'without friends overlap' do
      before do
        FactoryGirl.create(:contact, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)])
        FactoryGirl.create(:contact, vectors: [FactoryGirl.create(:vector_email, value: email)])
      end

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let!(:contact_1) { FactoryGirl.create(:contact, owner_mkey: friend_1, vectors: [FactoryGirl.create(:vector_mobile, value: mobile), FactoryGirl.create(:vector_email, value: email)]) }
    let!(:contact_2) { FactoryGirl.create(:contact, owner_mkey: friend_2, vectors: [FactoryGirl.create(:vector_email, value: email)]) }
    let!(:subject) { instance.save }
    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'contact_of_friends' }
    it { expect(subject.persisted?).to be true }
    it { expect(contact.additions['friends_with_contact']).to include *[contact_1.owner.mkey, contact_2.owner.mkey] }
  end
end
