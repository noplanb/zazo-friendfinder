require 'rails_helper'

RSpec.describe Template, type: :model do
  describe 'validations' do
    def instance_errors(attr, value)
      instance = described_class.new attr => value
      instance.valid?
      instance.errors.messages[attr]
    end

    it { is_expected.to validate_presence_of :category }
    it { is_expected.to validate_presence_of :kind }
    it { is_expected.to validate_presence_of :content }

    context 'category' do
      it { expect(instance_errors(:category, 'user_joined')).to be nil }
      it { expect(instance_errors(:category, 'fake_user_joined')).to be nil }
      it { expect(instance_errors(:category, 'unexpected')).to_not be nil }
    end

    context 'kind' do
      it { expect(instance_errors(:kind, 'email')).to be nil }
      it { expect(instance_errors(:kind, 'mobile_notification')).to be nil }
      it { expect(instance_errors(:kind, 'unexpected')).to_not be nil }
    end

    context 'unique kind category' do
      context 'when unique' do
        let(:instance) { described_class.new category: 'user_joined', kind: 'mobile_notification' }
        before do
          FactoryGirl.create :template, category: 'user_joined', kind: 'email'
          instance.valid?
        end

        it { expect(instance.errors.messages[:category]).to be nil }
        it { expect(instance.errors.messages[:kind]).to be nil }
      end

      context 'when not unique' do
        let(:instance) { described_class.new category: 'user_joined', kind: 'email' }
        before do
          FactoryGirl.create :template, category: 'user_joined', kind: 'email'
          instance.valid?
        end

        it { expect(instance.errors.messages[:category]).to eq ['template with pair (email,user_joined) already exist'] }
        it { expect(instance.errors.messages[:kind]).to eq ['template with pair (email,user_joined) already exist'] }
      end
    end
  end
end
