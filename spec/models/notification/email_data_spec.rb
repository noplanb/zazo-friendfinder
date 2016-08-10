require 'rails_helper'

RSpec.describe Notification::EmailData, type: :model do
  let(:contact) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS') }
  let(:notification) { create(:notification, contact: contact) }
  let(:instance) { described_class.new(notification) }

  describe '#get', vcr: { cassette: 'when_valid' } do
    subject { instance.get }

    it do
      expected = {
        to: 'vano468@gmail.com',
        from: 'Zazo <support@zazoapp.com>',
        subject: "#{contact.display_name} joined Zazo!",
        body: notification.compiled_content }
      is_expected.to eq(expected)
    end
  end

  describe 'validations' do
    subject { instance.valid? }

    before { subject }

    context 'when valid', vcr: { cassette: 'when_valid' } do
      it { is_expected.to be(true) }
    end

    context 'when invalid: email not persisted', vcr: { cassette: 'when_invalid_by_email' } do
      let(:contact) { create(:contact, owner_mkey: 'XqUn9Fs5YHd75l1rin76') }

      it { is_expected.to be(false) }
      it { expect(instance.errors.messages[:email]).to eq ['can\'t be blank'] }
    end

    context 'when invalid: owner mkey is invalid', vcr: { cassette: 'when_invalid_by_mkey' } do
      let(:contact) { create(:contact, owner_mkey: 'xxxxxxxxxxxx') }

      it { is_expected.to be(false) }
      it { expect(instance.errors.messages[:response]).to eq([{ 'user' => ['can\'t be blank'] }]) }
    end
  end
end
