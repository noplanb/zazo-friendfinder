require 'rails_helper'

RSpec.describe Notification::Send do
  let(:instance) { described_class.new [notification] }

  describe '#do' do
    def instance_do_without_exceptions
      instance.do; rescue
    end

    #
    # email notification
    #

    context 'when email notification' do
      use_vcr_cassette 'notification/fetch_emails_persisted', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_not_persisted', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_incorrect_email', api_base_urls
      use_vcr_cassette 'notification/fetch_emails_nonexistent_owner', api_base_urls

      let(:template) { FactoryGirl.create :template_email }
      let(:notification) do
        FactoryGirl.create :notification, compiled_content: 'Hello from Russia!', contact: contact, template: template
      end
      subject { notification.reload.state }

      context 'when contact owner is existing zazo user with persisted emails' do
        use_vcr_cassette 'notification/send_email_notification_success', api_base_urls

        let(:contact) { FactoryGirl.create :contact, owner_mkey: 'ZcAK4dM9S4m0IFui6ok6' }
        before { instance.do }

        it { is_expected.to eq 'sent' }
      end

      context 'when contact owner is existing zazo user without persisted emails' do
        let(:contact) { FactoryGirl.create :contact, owner_mkey: 'XqUn9Fs5YHd75l1rin76' }
        before { instance.do }

        it { is_expected.to eq 'canceled' }
      end

      context 'when contact owner is not exist' do
        let(:contact) { FactoryGirl.create :contact, owner_mkey: 'xxxxxxxxxxxx' }

        it do
          instance_do_without_exceptions
          is_expected.to eq 'error'
        end
        it { expect { instance.do }.to raise_error(Faraday::ClientError) }
      end

      context 'when email is not correct' do
        use_vcr_cassette 'notification/send_email_notification_failure', api_base_urls

        let(:contact) { FactoryGirl.create :contact, owner_mkey: '1IsLHzYF4sM52M7jEgQe' }
        before { instance.do }

        it { is_expected.to eq 'error' }
      end
    end

    #
    # mobile notification
    #

    context 'when mobile notification' do

    end
  end
end
