require 'rails_helper'

RSpec.describe Notification::MobileData, type: :model do
  let(:contact) { FactoryGirl.create(:contact, owner_mkey: '7qdanSEmctZ2jPnYA0a1') }
  let(:push_token) { 'APA91bEt9ugdWHeAUfvSM4IPnUCIvDzkc17pSWV2EUBDdyuF-mePW89QHIBeT9jgzaifMREzWUIGXb33wMSEt439xFtSj1jXIt4y29KmokOw-rTZlHKYlNT5Z6QHe9T2B_JHJsARhnCN' }
  let(:notification) { FactoryGirl.create(:notification, contact: contact) }
  let(:instance) { described_class.new(notification) }

  describe '#get' do
    subject { instance.get }

    it do
      expected = {
        subject: "#{contact.display_name} joined Zazo!",
        device_build: 'prod',
        device_platform: 'android',
        device_token: push_token,
        payload: {
          type: 'friend_joined',
          content: notification.compiled_content,
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
      let(:contact) { FactoryGirl.create(:contact, owner_mkey: 'xxxxxxxxxxxx') }

      it { is_expected.to be false }
      it { expect(instance.errors.messages[:response]).to eq [{ 'push_user' => ['user mkey is not correct'] }] }
    end
  end
end
