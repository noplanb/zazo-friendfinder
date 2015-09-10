require 'rails_helper'

RSpec.describe Score::Criterias::ActivityOnZazo do
  let(:connection) { FactoryGirl.create :contact, zazo_mkey: mkey }
  let(:instance) { described_class.new connection }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'with correct mkey by very active user' do
      use_vcr_cassette 'score/criterias/activity_on_zazo_by_7qdanSEmctZ2jPnYA0a1', api_base_urls
      let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }

      it { is_expected.to eq 273 }
    end

    context 'with correct mkey by not very active user' do
      use_vcr_cassette 'score/criterias/activity_on_zazo_by_GBAHb0482YxlJ0kYwbIS', api_base_urls
      let(:mkey) { 'GBAHb0482YxlJ0kYwbIS' }

      it { is_expected.to eq 7 }
    end

    context 'with incorrect mkey' do
      use_vcr_cassette 'score/criterias/activity_on_zazo_by_incorrect', api_base_urls
      let(:mkey) { 'xxxxxxxxxxxx' }

      it { is_expected.to eq 0 }
    end

    context 'when user in not registered on zazo' do
      let(:connection) { FactoryGirl.create :contact }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    use_vcr_cassette 'score/criterias/activity_on_zazo_by_7qdanSEmctZ2jPnYA0a1', api_base_urls
    let(:mkey) { '7qdanSEmctZ2jPnYA0a1' }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'activity_on_zazo' }
    it { expect(subject.persisted?).to be true }
  end
end
