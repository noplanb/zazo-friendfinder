require 'rails_helper'

RSpec.describe Score::Criterias::IsContactFavorite do
  let(:connection) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new connection }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

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

  describe '#save' do
    let(:vectors) { [FactoryGirl.create(:vector_mobile_marked_as_favorite)] }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'is_contact_favorite' }
    it { expect(subject.persisted?).to be true }
  end
end
