require 'rails_helper'

RSpec.describe Score::Criterias::ActivityOnZazo do
  let(:connection) { FactoryGirl.create :contact, zazo_mkey: mkey }
  let(:instance) { described_class.new connection }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'with correct mkey' do
      let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }

      it { is_expected.to eq 0 }
    end

    context 'with incorrect mkey' do
      let(:mkey) { 'xxxxxxxxxxxx' }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'activity_on_zazo' }
    it { expect(subject.persisted?).to be true }
  end
end
