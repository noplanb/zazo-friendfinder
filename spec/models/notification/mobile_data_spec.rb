require 'rails_helper'

RSpec.describe Notification::MobileData, type: :model do
  let(:contact) { FactoryGirl.create(:contact, owner_mkey: '7qdanSEmctZ2jPnYA0a1') }
  let(:push_token) { '3754373c614e788141e40a68a82a28fe48bcc35e3e29294d73cae7c1399e796a' }
  let(:notification) { FactoryGirl.create(:notification_mobile, contact: contact) }
  let(:instance) { described_class.new(notification) }

  describe '#get' do
    subject { instance.get }

    it do
      expected = {
        subject: "#{contact.display_name} joined Zazo!",
        device_build: 'prod',
        device_platform: 'ios',
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
