require 'rails_helper'

RSpec.describe WebClient::ActionHandler do
  let(:contact) { FactoryGirl.create(:contact) }
  let(:notification) { FactoryGirl.create(:notification, contact: contact) }
  let(:nkey) { notification.nkey }
  let(:owner) { contact.owner }
  let(:instance) { described_class.new(nkey) }

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
        it { expect(contact.additions['ignored_by_owner']).to eq true }
      end

      context 'another contact' do
        let(:another_contact) { FactoryGirl.create(:contact, owner_mkey: contact.owner_mkey) }

        it { expect(notification.status).to eq 'no_feedback' }
        it { expect(another_contact.additions['ignored_by_owner']).to eq true }
      end
    end
  end

  describe '#unsubscribe' do
    before do
      instance.unsubscribe
      notification.reload
    end

    it { expect(contact.owner.unsubscribed?).to be true }
    it { expect(notification.status).to eq 'no_feedback' }
  end

  describe '#subscribe' do
    before do
      instance.subscribe
      notification.reload
    end

    it { expect(contact.owner.subscribed?).to be true }
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
