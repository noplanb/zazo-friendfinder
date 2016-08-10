require 'rails_helper'

RSpec.describe Score::Criteria::IgnoredByOwner do
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'when contact is ignored' do
      let(:contact) { create :contact, additions: { ignored_by_owner: true } }

      it { is_expected.to eq -100000 }
    end

    context 'when contact is not ignored' do
      let(:contact) { create :contact }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:contact) { create :contact, additions: { ignored_by_owner: true } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'ignored_by_owner' }
    it { expect(subject.value).to eq -100000 }
    it { expect(subject.persisted?).to be true }
  end
end
