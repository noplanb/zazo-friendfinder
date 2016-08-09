require 'rails_helper'

RSpec.describe Vector, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :contact }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }

    describe '#additions_must_be_allowed' do
      before { vector.valid? }

      context 'valid' do
        context 'mobile' do
          let(:vector) { build :vector_mobile, additions: { sms_messages_sent: 15 } }

          it { expect(vector).to be_valid }
        end

        context 'email' do
          let(:vector) { build :vector_email, additions: { email_messages_sent: 65 } }

          it { expect(vector).to be_valid }
        end

        context 'facebook' do
          let(:vector) { build :vector_facebook }

          it { expect(vector).to be_valid }
        end
      end

      context 'invalid' do
        context 'mobile' do
          let(:vector) { build :vector_mobile, additions: { email_messages_sent: 15 } }

          it { expect(vector).to be_invalid }
          it { expect(vector.errors.messages).to eq({ additions: ['\'email_messages_sent\' is not allowed condition for \'mobile\' vector']}) }
        end

        context 'email' do
          let(:vector) { build :vector_email, additions: { sms_messages_sent: 65 } }

          it { expect(vector).to be_invalid }
          it { expect(vector.errors.messages).to eq({ additions: ['\'sms_messages_sent\' is not allowed condition for \'email\' vector']}) }
        end

        context 'facebook' do
          let(:vector) { build :vector_facebook, additions: { marked_as_favorite: true } }

          it { expect(vector).to be_invalid }
          it { expect(vector.errors.messages).to eq({ additions: ['\'marked_as_favorite\' is not allowed condition for \'facebook\' vector']}) }
        end
      end
    end

    describe '#value_has_correct_format' do
      before { vector.valid? }

      context 'valid mobile' do
        let(:vector) { build :vector_mobile }

        it { expect(vector).to be_valid }
      end

      context 'invalid mobile' do
        let(:vector) { build :vector_mobile, value: 'xxxxxxxxx' }

        it { expect(vector).to be_invalid }
        it { expect(vector.errors.messages).to eq({ value: ['\'xxxxxxxxx\' has incorrect format for \'mobile\' vector']}) }
      end

      context 'valid email' do
        let(:vector) { build :vector_email }

        it { expect(vector).to be_valid }
      end

      context 'invalid email' do
        let(:vector) { build :vector_email, value: 'asdasd@asdasd' }

        it { expect(vector).to be_invalid }
        it { expect(vector.errors.messages).to eq({ value: ['\'asdasd@asdasd\' has incorrect format for \'email\' vector']}) }
      end
    end
  end
end
