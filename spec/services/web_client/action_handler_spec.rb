require 'rails_helper'

RSpec.describe WebClient::ActionHandler do
  let(:contact) { FactoryGirl.create(:contact) }
  let(:notification) { FactoryGirl.create(:notification, contact: contact) }
  let(:nkey) { notification.nkey }
  let(:instance) { described_class.new(nkey) }

=begin
  describe '#do' do
    let(:notification) { FactoryGirl.create :notification, contact: contact }
    let(:nkey) { notification.nkey }

    before do
      instance.do action
      notification.reload
    end

    context 'add' do
      let(:action) { :added }
      it { expect(notification.status).to eq 'added' }
    end

    context 'ignore' do
      let(:action) { :ignored }
      it { expect(notification.status).to eq 'ignored' }
    end

    context 'unsubscribe' do
      let(:action) { :unsubscribed }
      it { expect(notification.status).to eq 'unsubscribed' }
    end

    context 'nil' do
      let(:action) { nil }
      before { :unsubscribed }
      it { expect(notification.status).to eq nil }
    end
  end
=end

  describe '#add and #ignore' do
    before do
      instance.send(action, another_contact)
      notification.reload
      contact.reload
      another_contact.reload if another_contact
    end

    describe '#add' do
      let(:action) { :add }

      context 'this contact' do
        let(:another_contact) { nil }

        it { expect(notification.status).to eq 'added' }
        it { expect(contact.additions['added_by_owner']).to eq true }
      end

      context 'another contact' do
        let(:another_contact) { FactoryGirl.create(:contact, owner_mkey: contact.owner_mkey) }

        it { expect(notification.status).to eq 'no_feedback' }
        it { expect(another_contact.additions['added_by_owner']).to eq true }
      end
    end

    describe '#ignore' do
      let(:action) { :ignore }

      context 'this contact' do
        let(:another_contact) { nil }

        it { expect(notification.status).to eq 'ignored' }
        it { expect(contact.additions['rejected_by_owner']).to eq true }
      end

      context 'another contact' do
        let(:another_contact) { FactoryGirl.create(:contact, owner_mkey: contact.owner_mkey) }

        it { expect(notification.status).to eq 'no_feedback' }
        it { expect(another_contact.additions['rejected_by_owner']).to eq true }
      end
    end
  end

  describe '#unsubscribe' do
    before do
      instance.unsubscribe
      notification.reload
    end

    # TODO: add addition spec
    it { expect(notification.status).to eq 'no_feedback' }
  end

  describe '#subscribe' do
    before do
      instance.subscribe
      notification.reload
    end

    # TODO: add addition spec
    it { expect(notification.status).to eq 'no_feedback' }
  end

  describe '#valid?' do
    subject { instance.valid? }

    context 'when valid' do
      let(:nkey) { FactoryGirl.create(:notification, contact: contact).nkey }
      it { is_expected.to be true }
    end

    context 'when invalid' do
      let(:nkey) { 'xxxxxxxxxxxx' }
      it { is_expected.to be false }
    end
  end
end
