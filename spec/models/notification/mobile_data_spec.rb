require 'rails_helper'

RSpec.describe Notification::MobileData, type: :model do
  use_vcr_cassette 'notification/fetch_push_user_valid_mkey', api_base_urls
  use_vcr_cassette 'notification/fetch_push_user_invalid_mkey', api_base_urls

  let(:contact) { FactoryGirl.create :contact, owner_mkey: '7qdanSEmctZ2jPnYA0a1' }
  let(:push_token) { 'APA91bH8Xy20cWQaP0kbEnps63ziDqwKjEC9GNn-BUsQ7avs8OkMATHSskfZbvLJe02qf9N_qsmxsqgqEaPVdL5iPGOhAhhtLZqo_njxViZUBThdD2ISAiaYfvAJ14ow6_mcydaj_Ubr' }
  let(:notification) do
    FactoryGirl.create :notification, compiled_content: 'Hello from Russia!', contact: contact
  end
  let(:instance) { described_class.new notification }

  describe '#get' do
    subject { instance.get }

    it do
      expected = {
        subject: "#{contact.display_name} joined Zazo!",
        device_platform: 'ios',
        device_build: 'prod',
        device_token: push_token,
        payload: {
          type: 'friend_joined',
          content: 'Hello from Russia!',
          subject: "#{contact.display_name} joined Zazo!",
          nkey: notification.nkey,
          additions: {
            friend_name: contact.display_name
          }
        }
      }
      is_expected.to eq expected
    end
  end

  describe 'validations' do
    subject { instance.valid? }
    before  { subject }

    context 'when valid' do
      it { is_expected.to be true }
    end

    context 'when invalid: owner mkey is invalid' do
      let(:contact) { FactoryGirl.create :contact, owner_mkey: 'xxxxxxxxxxxx' }

      it { is_expected.to be false }
      it { expect(instance.errors.messages[:response]).to eq [{ 'push_user' => ['user mkey is not correct'] }] }
    end

    context 'when invalid: content is not persisted' do
      let(:notification) { FactoryGirl.create :notification, contact: contact }

      it { is_expected.to be false }
      it { expect(instance.errors.messages[:content]).to eq ['can\'t be blank'] }
    end
  end
end
