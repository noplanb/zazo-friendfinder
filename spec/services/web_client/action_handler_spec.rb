require 'rails_helper'

RSpec.describe WebClient::ActionHandler do
  let(:contact) { FactoryGirl.create(:contact) }
  let(:notification) { FactoryGirl.create(:notification, contact: contact) }
  let(:nkey) { notification.nkey }
  let(:owner) { contact.owner }
  let(:instance) { described_class.new(nkey) }

  context 'add | ignore' do
    subject { instance.send(action, another_contact) }

    before do |example|
      unless example.metadata[:skip_before]
        subject
        notification.reload
        contact.reload
        another_contact.reload if another_contact
      end
    end

    describe '#add' do
      let(:action) { :add }

      context 'this contact' do
        let(:another_contact) { nil }

        it { expect(notification.status).to eq 'added' }
        it { expect(contact.additions['added_by_owner']).to eq true }
        it 'should dispatch an event', :skip_before do
          expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(2).times
          subject
        end
      end

      context 'another contact' do
        let(:another_contact) { FactoryGirl.create(:contact, owner_mkey: contact.owner_mkey) }

        it { expect(notification.status).to eq 'no_feedback' }
        it { expect(another_contact.additions['added_by_owner']).to eq true }
        it 'should not dispatch an event', :skip_before do
          expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(1).times
          subject
        end
      end
    end

    describe '#ignore' do
      let(:action) { :ignore }

      context 'this contact' do
        let(:another_contact) { nil }

        it { expect(notification.status).to eq 'ignored' }
        it { expect(contact.additions['ignored_by_owner']).to eq true }
        it 'should dispatch an event', :skip_before do
          expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(2).times
          subject
        end
      end

      context 'another contact' do
        let(:another_contact) { FactoryGirl.create(:contact, owner_mkey: contact.owner_mkey) }

        it { expect(notification.status).to eq 'no_feedback' }
        it { expect(another_contact.additions['ignored_by_owner']).to eq true }
        it 'should not dispatch an event', :skip_before do
          expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(1).times
          subject
        end
      end
    end
  end

  context 'subscribe | unsubscribe' do
    subject { instance.send(action) }

    before do |example|
      unless example.metadata[:skip_before]
        subject
        notification.reload
      end
    end

    describe '#unsubscribe' do
      let(:action) { :unsubscribe }

      it { expect(contact.owner.unsubscribed?).to be true }
      it { expect(notification.status).to eq 'no_feedback' }
      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(1).times
        subject
      end
    end

    describe '#subscribe' do
      let(:action) { :subscribe }

      it { expect(contact.owner.subscribed?).to be true }
      it { expect(notification.status).to eq 'no_feedback' }
      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to receive(:emit).exactly(1).times
        subject
      end
    end
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
