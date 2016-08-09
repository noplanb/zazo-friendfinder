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

      context 'when contact owner is existing zazo user with persisted emails' do
        let(:contact) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }

        it { is_expected.to eq 'sent' }
      end

      context 'when contact owner is existing zazo user without persisted emails' do
        let(:contact) { create(:contact, owner_mkey: 'XqUn9Fs5YHd75l1rin76') }

        it { is_expected.to eq 'canceled' }
      end

      context 'when contact owner is not exist' do
        let(:contact) { create(:contact, owner_mkey: 'xxxxxxxxxxxx') }

        it { is_expected.to eq 'canceled' }
      end

=begin
      context 'when email is not correct' do
        let(:contact) { create(:contact, owner_mkey: 'dz4X0EvprPJO6fGysT8X') }

        it { is_expected.to eq 'error' }
      end
=end
    end

    #
    # mobile notification
    #

    context 'when mobile notification' do
      let(:kind) { 'mobile' }
      subject { notification.reload.state }

      context 'when contact owner is existing zazo push_user' do
        let(:contact) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }

        it { is_expected.to eq 'sent' }
      end

      context 'when contact owner is not existing zazo push_user' do
        it
      end
    end
  end
end
