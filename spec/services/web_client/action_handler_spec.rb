require 'rails_helper'

RSpec.describe WebClient::ActionHandler do
  let(:contact) { FactoryGirl.create :contact }
  let(:instance) { described_class.new nkey }

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
