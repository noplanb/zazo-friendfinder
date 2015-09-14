require 'rails_helper'

RSpec.describe Score::Criterias::FriendOfFriends do
  use_vcr_cassette 'score/criterias/friend_of_friends_by_GBAHb0482YxlJ0kYwbIS', api_base_urls

  let(:owner) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:friend) { '7qdanSEmctZ2jPnYA0a1' }

  let(:contact) { FactoryGirl.create :contact, owner: owner, zazo_mkey: friend }
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    context 'with defined zazo_mkey' do
      subject { instance.calculate_with_ratio }

      it { is_expected.to eq 16 }
    end

    context 'without defined zazo_mkey' do
      let(:contact) { FactoryGirl.create :contact }
      subject { instance.calculate_with_ratio }

      it { is_expected.to eq 0 }
    end

    context 'without incorrect zazo mkeys' do
      use_vcr_cassette 'score/criterias/friend_of_friends_by_incorrect_mkeys', api_base_urls
      let(:incorrect) { 'xxxxxxxxxxxx' }
      let(:contact) { FactoryGirl.create :contact, owner: incorrect, zazo_mkey: incorrect }
      subject { instance.calculate_with_ratio }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do

  end
end
