require 'rails_helper'

RSpec.describe Score::Criterias::RejectedByOwner do
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'when contact is rejected' do
      let(:contact) { FactoryGirl.create :contact, additions: { 'rejected_by_owner' => true } }

      it { is_expected.to eq -100000 }
    end

    context 'when contact is not rejected' do
      let(:contact) { FactoryGirl.create :contact }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:contact) { FactoryGirl.create :contact, additions: { 'rejected_by_owner' => true } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'rejected_by_owner' }
    it { expect(subject.persisted?).to be true }
  end
end
