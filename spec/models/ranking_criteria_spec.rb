require 'rails_helper'

RSpec.describe RankingCriteria, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :method }
    it { is_expected.to validate_presence_of :score }
    it { is_expected.to validate_numericality_of :score }
  end
end
