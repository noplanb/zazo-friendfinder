require 'rails_helper'

RSpec.describe Score::Criteria::FriendOfFriends do
  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:friend) { '7qdanSEmctZ2jPnYA0a1' }
  let(:mutual) { '0DAQEVtmNKQiW6aoQrvo' }

  let(:contact) { create(:contact, owner_mkey: owner_mkey, zazo_mkey: friend) }
  let(:instance) { described_class.new(contact) }

  describe '#calculate_with_ratio' do
    context 'with defined zazo_mkey',
      vcr: { cassette: 'with_zazo_mkey'} do
      subject { instance.calculate_with_ratio }

      it { is_expected.to eq(16) }
    end

    context 'without defined zazo_mkey',
      vcr: { cassette: 'without_zazo_mkey'} do
      let(:contact) { create(:contact) }

      subject { instance.calculate_with_ratio }

      it { is_expected.to eq(0) }
    end

    context 'with incorrect zazo_mkey',
      vcr: { cassette: 'with_incorrect_zazo_mkey'} do
      let(:incorrect) { 'xxxxxxxxxxxx' }
      let(:contact) { create(:contact, owner_mkey: incorrect, zazo_mkey: incorrect) }

      subject { instance.calculate_with_ratio }

      it { is_expected.to eq(0) }
    end
  end

  describe '#save',
    vcr: { cassette: 'with_zazo_mkey'} do
    let!(:subject) { instance.save }

    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq('friend_of_friends') }
    it { expect(subject.persisted?).to be(true) }
    it { expect(contact.additions).to eq('friends_who_are_friends_with_contact' => [mutual]) }
  end
end
