require 'rails_helper'

RSpec.describe Score::Criteria::ContactOfFriends do
  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:friend_1) { '0DAQEVtmNKQiW6aoQrvo' }
  let(:friend_2) { '7qdanSEmctZ2jPnYA0a1' }

  let(:contact) { create(:contact, owner_mkey: owner_mkey, vectors: vectors) }
  let(:instance) { described_class.new(contact) }

  let(:email) { 'elfishawy.sani@gmail.com' }
  let(:mobile) { '+16502453537' }
  let(:vectors) do
    [create(:vector_email, value: email),
     create(:vector_mobile, value: mobile)]
  end

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'by two friends overlap',
      vcr: { cassette: 'by_two_friends_overlap'} do
      before do
        create(:contact, owner_mkey: friend_1,
          vectors: [build(:vector_mobile, value: mobile)])
        create(:contact, owner_mkey: friend_2,
          vectors: [build(:vector_email, value: email)])
        create(:contact,
          vectors: [build(:vector_email, value: email)])
      end

      it { is_expected.to eq(16) }
    end

    context 'by one friend overlap',
      vcr: { cassette: 'by_one_friend_overlap'} do
      before do
        create(:contact, owner_mkey: friend_1,
          vectors: [build(:vector_mobile, value: mobile), build(:vector_email, value: email)])
        create(:contact,
          vectors: [build(:vector_email, value: email)])
      end

      it { is_expected.to eq(8) }
    end

    context 'without friends overlap',
      vcr: { cassette: 'without_friends_overlap'} do
      before do
        create(:contact,
          vectors: [build(:vector_mobile, value: mobile)])
        create(:contact,
          vectors: [build(:vector_email, value: email)])
      end

      it { is_expected.to eq(0) }
    end
  end

  describe '#save',
    vcr: { cassette: 'by_two_friends_overlap'} do
    let!(:contact_1) do
      create(:contact, owner_mkey: friend_1,
        vectors: [build(:vector_mobile, value: mobile), build(:vector_email, value: email)])
    end
    let!(:contact_2) do
      create(:contact, owner_mkey: friend_2,
        vectors: [build(:vector_email, value: email)])
    end
    let!(:subject) { instance.save }

    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq('contact_of_friends') }
    it { expect(subject.persisted?).to be(true) }
    it { expect(contact.additions['friends_with_contact']).to match_array([contact_1.owner.mkey, contact_2.owner.mkey]) }
  end
end
