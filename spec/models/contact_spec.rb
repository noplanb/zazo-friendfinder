require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :owner_mkey }
  end
end
