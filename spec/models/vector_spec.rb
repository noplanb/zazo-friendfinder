require 'rails_helper'

RSpec.describe Vector, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :contact }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :value }
  end
end
