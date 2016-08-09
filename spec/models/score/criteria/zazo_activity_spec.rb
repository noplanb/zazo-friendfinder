require 'rails_helper'

RSpec.describe Score::Criteria::ZazoActivity do
  let(:connection) { create(:contact, zazo_mkey: mkey) }
  let(:instance) { described_class.new(connection) }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'with correct mkey by very active user',
      vcr: { cassette: 'by_very_active_user'} do
      let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }

      it { is_expected.to eq(2880) }
    end

    context 'with correct mkey by not very active user',
      vcr: { cassette: 'by_not_very_active_user'} do
      let(:mkey) { 'GBAHb0482YxlJ0kYwbIS' }

      it { is_expected.to eq(112) }
    end

    context 'with incorrect mkey',
      vcr: { cassette: 'by_incorrect_mkey'} do
      let(:mkey) { 'xxxxxxxxxxxx' }

      it { is_expected.to eq(0) }
    end

    context 'when user is not registered on zazo' do
      let(:connection) { create(:contact) }

      it { is_expected.to eq(0) }
    end
  end

  describe '#save',
    vcr: { cassette: 'by_very_active_user'} do
    let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }

    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq('zazo_activity') }
    it { expect(subject.persisted?).to be(true) }
  end
end
