require 'rails_helper'

RSpec.describe RankingCriteria::Criterias::NumberOfVectors do
  describe '#calculate_with_ratio' do
    let(:connection) { FactoryGirl.create :connection, vectors: vectors }
    subject { described_class.new(connection).calculate_with_ratio }

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
end
