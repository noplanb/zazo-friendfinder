require 'rails_helper'

RSpec.describe Contact::GetZazoFriends do
  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:contact) { FactoryGirl.create :contact, owner_mkey: owner_mkey }
  let(:instance) { described_class.new contact }

  describe '#do' do
    subject { instance.do }

    context 'for existing user' do
      use_vcr_cassette 'contact/get_zazo_friends_GBAHb0482YxlJ0kYwbIS', api_base_urls

      it { is_expected.to match_array %w(0DAQEVtmNKQiW6aoQrvo e0kvxfgua1EQJvUOzVC1 yLK6i5VpMW9ZZy5BnXZZ 7qdanSEmctZ2jPnYA0a1 gpIES8adSGtrB5O5933c LVXE6gyoxb6eHNvPd96f) }
    end

    context 'for nonexistent user' do
      use_vcr_cassette 'contact/get_zazo_friends_for_nonexistent_user', api_base_urls
      let(:owner_mkey) { 'xxxxxxxxxxxx' }

      it { is_expected.to eq [] }
    end
  end
end
