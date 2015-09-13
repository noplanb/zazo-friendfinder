require 'rails_helper'

RSpec.describe Score::Criterias::NumSmsSent do
  let(:contact) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    let(:connection) { FactoryGirl.create :contact, vectors: vectors }
    subject { instance.calculate_with_ratio }

    context 'with multiple vectors messages_sent' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 32 }),
        FactoryGirl.create(:vector_email, additions: { email_messages_sent: 56 }),
      ]}
      it { is_expected.to eq 41 }
    end

    context 'with mobile vector sms_messages_sent' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 21 }),
        FactoryGirl.create(:vector_email)
      ]}
      it { is_expected.to eq 32 }
    end

    context 'with email vector email_messages_sent' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email, additions: { email_messages_sent: 23 })
      ]}
      it { is_expected.to eq 0 }
    end

    context 'with not defined sms_messages_sent' do
      let(:vectors) { [FactoryGirl.create(:vector_mobile)] }
      it { is_expected.to eq 0 }
    end

    context 'without phone vector' do
      let(:vectors) { [FactoryGirl.create(:vector_email)] }
      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:vectors) { [FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 21 })] }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'num_sms_sent' }
    it { expect(subject.persisted?).to be true }
  end
end
