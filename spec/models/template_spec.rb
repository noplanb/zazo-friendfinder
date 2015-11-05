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
    it { is_expected.to validate_presence_of :is_active }
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
  end
end
