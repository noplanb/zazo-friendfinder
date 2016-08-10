require 'rails_helper'

RSpec.describe Score::Criteria::NumEmailsSent do
  let(:contact) { create(:contact, vectors: vectors) }
  let(:instance) { described_class.new(contact) }

  describe '#calculate_with_ratio' do
    let(:connection) { create(:contact, vectors: vectors) }
    subject { instance.calculate_with_ratio }

    context 'with multiple vectors messages_sent' do
      let(:vectors) do
        [ create(:vector_mobile, additions: { sms_messages_sent: 32 }),
          create(:vector_email, additions: { email_messages_sent: 56 }) ]
      end
      it { is_expected.to eq 60 }
    end

    context 'with email vector email_messages_sent' do
      let(:vectors) do
        [ create(:vector_email, additions: { email_messages_sent: 21 }),
          create(:vector_mobile) ]
      end
      it { is_expected.to eq 32 }
    end

    context 'with mobile vector sms_messages_sent' do
      let(:vectors) do
        [ create(:vector_email),
          create(:vector_mobile, additions: { sms_messages_sent: 23 }) ]
      end
      it { is_expected.to eq 0 }
    end

    context 'with not defined email_messages_sent' do
      let(:vectors) { [create(:vector_email)] }

      it { is_expected.to eq 0 }
    end

    context 'without email vector' do
      let(:vectors) { [create(:vector_mobile)] }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:vectors) { [create(:vector_email, additions: { email_messages_sent: 21 })] }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'num_emails_sent' }
    it { expect(subject.persisted?).to be true }
  end
end
