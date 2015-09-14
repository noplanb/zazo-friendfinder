require 'rails_helper'

RSpec.describe Score::Criterias::RecommendedByFriends do
  let(:instance) { described_class.new contact }

  let(:user_1) { FactoryGirl.build :user }
  let(:user_2) { FactoryGirl.build :user }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'recommended by two users' do
      let(:contact) { FactoryGirl.create :contact, additions: { 'recommended_by' => [user_1.mkey, user_2.mkey] } }

      it { is_expected.to eq 48 }
    end

    context 'recommended by one user' do
      let(:contact) { FactoryGirl.create :contact, additions: { 'recommended_by' => [user_1.mkey] } }

      it { is_expected.to eq 24 }
    end

    context 'without recommendation' do
      let(:contact) { FactoryGirl.create :contact }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:contact) { FactoryGirl.create :contact, additions: { 'recommended_by' => [user_1.mkey, user_2.mkey] } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'recommended_by_friends' }
    it { expect(subject.persisted?).to be true }
  end
end
