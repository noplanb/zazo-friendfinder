require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    def instance_errors(attr, value)
      instance = described_class.new attr => value
      instance.valid?
      instance.errors.messages[attr]
    end

    it { is_expected.to validate_presence_of :contact }
    it { is_expected.to validate_presence_of :nkey }

    context 'state' do
      it { expect(instance_errors(:state, 'sent')).to be nil }
      it { expect(instance_errors(:state, 'error')).to be nil }
      it { expect(instance_errors(:state, 'canceled')).to be nil }
      it { expect(instance_errors(:state, 'unexpected')).to_not be nil }
      it { expect(instance_errors(:state, nil)).to be nil }
    end

    context 'status' do
      it { expect(instance_errors(:status, 'added')).to be nil }
      it { expect(instance_errors(:status, 'ignored')).to be nil }
      it { expect(instance_errors(:status, 'unsubscribed')).to be nil }
      it { expect(instance_errors(:status, 'unexpected')).to_not be nil }
      it { expect(instance_errors(:status, nil)).to be nil }
    end
  end
end
