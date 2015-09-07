require 'rails_helper'

RSpec.describe Connection, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :owner }
    it { is_expected.to validate_presence_of :expires_at }
  end
end
