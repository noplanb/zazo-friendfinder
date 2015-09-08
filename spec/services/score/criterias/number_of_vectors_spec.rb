require 'rails_helper'

RSpec.describe Score::Criterias::NumberOfVectors do
  let(:connection) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new connection }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'contact with 3 vectors' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email),
        FactoryGirl.create(:vector_facebook)
      ]}

      it { is_expected.to eq 12 }
    end

    context 'contact with 2 vectors' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email)
      ]}

      it { is_expected.to eq 8 }
    end

    context 'contact with 1 vector' do
      let(:vectors) { [FactoryGirl.create(:vector_mobile)] }

      it { is_expected.to eq 4 }
    end

    context 'contact with 0 vectors' do
      let(:vectors) { [] }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:vectors) { [FactoryGirl.create(:vector_mobile_favorite)] }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'number_of_vectors' }
    it { expect(subject.persisted?).to be_true }
  end
end
