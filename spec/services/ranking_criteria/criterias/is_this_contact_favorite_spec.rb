require 'rails_helper'

RSpec.describe RankingCriteria::Criterias::IsThisContactFavorite do
  describe '#calculate_with_ratio' do
    let(:connection) { FactoryGirl.create :connection, vectors: vectors }
    subject { described_class.new(connection).calculate_with_ratio }

    context 'when contact is marked as favorite once' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { marked_as_favorite: true }),
        FactoryGirl.create(:vector_email)
      ]}
      it { is_expected.to eq 10 }
    end

    context 'when contact is double marked as favorite' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile, additions: { marked_as_favorite: true }),
        FactoryGirl.create(:vector_email,  additions: { marked_as_favorite: true })
      ]}
      it { is_expected.to eq 10 }
    end

    context 'when contact is not marked' do
      let(:vectors) {[
        FactoryGirl.create(:vector_mobile),
        FactoryGirl.create(:vector_email, additions: { messages_sent: 12 })
      ]}
      it { is_expected.to eq 0 }
    end
  end
end
