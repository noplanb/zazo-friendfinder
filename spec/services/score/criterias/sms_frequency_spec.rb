require 'rails_helper'

RSpec.describe Score::Criterias::SmsFrequency do
  describe '#calculate_with_ratio' do
    let(:connection) { FactoryGirl.create :contact, vectors: vectors }
    subject { described_class.new(connection).calculate_with_ratio }

    context 'with multiple vectors messages_sent' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 48 }),
        FactoryGirl.create(:vector_email, additions: { email_messages_sent: 56 }),
      ]}
      it { is_expected.to eq 48 }
    end

    context 'with mobile vector sms_messages_sent' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 21 }),
        FactoryGirl.create(:vector_email)
      ]}
      it { is_expected.to eq 21 }
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
end
