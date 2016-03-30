require 'rails_helper'

RSpec.describe Notification::Send do
  let(:instance) { described_class.new(notification) }
  let(:notification) { FactoryGirl.create(:notification, kind: kind, contact: contact) }

  describe '#do' do
    #
    # email notification
    #

    context 'when email notification' do
      use_vcr_cassette 'notification/fetch_emails_persisted', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_not_persisted', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_incorrect_email', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_nonexistent_owner', api_base_urls

      let(:kind) { 'email' }
      subject { notification.reload.state }

      context 'when contact owner is existing zazo user with persisted emails' do
        use_vcr_cassette 'owner/fetch_data/attributes_by_GBAHb0482YxlJ0kYwbIS', api_base_urls
        use_vcr_cassette 'notification/send_email_notification_success', api_base_urls

        let(:contact) { FactoryGirl.create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }
        before { instance.do }

        it { is_expected.to eq 'sent' }
      end

      context 'when contact owner is existing zazo user without persisted emails' do
        let(:contact) { FactoryGirl.create(:contact, owner_mkey: 'XqUn9Fs5YHd75l1rin76') }
        before { instance.do }

        it { is_expected.to eq 'canceled' }
      end

      context 'when contact owner is not exist' do
        let(:contact) { FactoryGirl.create(:contact, owner_mkey: 'xxxxxxxxxxxx') }
        before { instance.do }

        it { is_expected.to eq 'canceled' }
      end

      context 'when email is not correct' do
        use_vcr_cassette 'notification/send_email_notification_failure', api_base_urls

        let(:contact) { FactoryGirl.create(:contact, owner_mkey: '1IsLHzYF4sM52M7jEgQe') }
        before { instance.do rescue nil }

        it { is_expected.to eq 'error' }
      end
    end

    #
    # mobile notification
    #

    context 'when mobile notification' do
      use_vcr_cassette 'notification/fetch_push_user_valid_mkey', api_base_urls
      use_vcr_cassette 'notification/fetch_push_user_invalid_mkey', api_base_urls

      let(:kind) { 'mobile' }
      subject { notification.reload.state }

      context 'when contact owner is existing zazo push_user' do
        use_vcr_cassette 'owner/fetch_data/attributes_by_7qdanSEmctZ2jPnYA0a1', api_base_urls
        use_vcr_cassette 'notification/send_mobile_notification_success', api_base_urls

        let(:contact) { FactoryGirl.create(:contact, owner_mkey: '7qdanSEmctZ2jPnYA0a1') }
        before { instance.do }

        it { is_expected.to eq 'sent' }
      end

      context 'when contact owner is not existing zazo push_user' do
        it
      end
    end
  end
end
