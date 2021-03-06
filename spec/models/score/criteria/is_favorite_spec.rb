require 'rails_helper'

RSpec.describe Score::Criteria::IsFavorite do
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'when contact is marked as favorite once' do
      let(:contact) { create :contact, additions: { marked_as_favorite: true } }

      it { is_expected.to eq 48 }
    end

    context 'when contact is not marked' do
      let(:contact) { create :contact }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:contact) { create :contact, additions: { marked_as_favorite: true } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'is_favorite' }
    it { expect(subject.persisted?).to be true }
  end
end
