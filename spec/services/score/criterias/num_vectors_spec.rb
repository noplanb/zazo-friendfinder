require 'rails_helper'

RSpec.describe Score::Criterias::NumVectors do
  let(:contact) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new contact }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'contact with 3 vectors' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email),
        FactoryGirl.create(:vector_facebook)
      ]}

      it { is_expected.to eq 3 }
    end

    context 'contact with 2 vectors' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email)
      ]}

      it { is_expected.to eq 2 }
    end

    context 'contact with 1 vector' do
      let(:vectors) { [FactoryGirl.create(:vector_mobile)] }

      it { is_expected.to eq 1 }
    end

    context 'contact with 0 vectors' do
      let(:vectors) { [] }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:vectors) { [FactoryGirl.create(:vector_mobile)] }
    let(:contact) { FactoryGirl.create :contact, vectors: vectors, additions: { marked_as_favorite: true } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'num_vectors' }
    it { expect(subject.persisted?).to be true }
  end
end
