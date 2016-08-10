require 'rails_helper'

RSpec.describe Notification::Send do
  let(:instance) { described_class.new(notification) }
  let(:notification) { create(:notification, kind: kind, contact: contact) }

  describe '#do' do
    #
    # email notification
    #

    before { instance.do }

    context 'when email notification' do
      let(:kind) { 'email' }

      subject { notification.reload.state }

      context 'when contact owner is existing zazo user with persisted emails',
        vcr: { cassette: 'email_when_owner_has_emails' } do
        let(:contact) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }

        it { is_expected.to eq('sent') }
      end

      context 'when contact owner is existing zazo user without persisted emails',
        vcr: { cassette: 'email_when_owner_has_not_emails' } do
        let(:contact) { create(:contact, owner_mkey: 'XqUn9Fs5YHd75l1rin76') }

        it { is_expected.to eq('canceled') }
      end

      context 'when contact owner is not exist',
        vcr: { cassette: 'email_when_owner_is_not_exist' } do
        let(:contact) { create(:contact, owner_mkey: 'xxxxxxxxxxxx') }

        it { is_expected.to eq('canceled') }
      end
    end

    #
    # mobile notification
    #

    context 'when mobile notification' do
      let(:kind) { 'mobile' }
      subject { notification.reload.state }

      context 'when contact owner is existing zazo push_user',
        vcr: { cassette: 'mobile_when_owner_has_push_user' } do
        let(:contact) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }

        it { is_expected.to eq('sent') }
      end
    end
  end
end
