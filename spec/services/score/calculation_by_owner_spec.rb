require 'rails_helper'

RSpec.describe Score::CalculationByOwner do
  let(:owner) { 'xxxxxxxxxxxx' }
  let(:instance) { described_class.new owner }

  describe '#do' do
    before do
      # first owner's contact
      vectors = [
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 12 }),
        FactoryGirl.create(:vector_email, additions: { marked_as_favorite: true })
      ]
      FactoryGirl.create :contact, owner: owner, vectors: vectors

      # second owner's contact
      vectors = [
        FactoryGirl.create(:vector_mobile, additions: { marked_as_favorite: true }),
      ]
      FactoryGirl.create :contact, owner: owner, vectors: vectors

      # non owner's contact
      vectors = [FactoryGirl.create(:vector_mobile, value: vectors.last.value)]
      FactoryGirl.create :contact, vectors: vectors
    end
    let!(:subject) { instance.do }

    it { is_expected.to be true }
    it { expect(Contact.by_owner(owner).count).to eq 2 }
    it { expect(Contact.by_owner(owner).map(&:total_score)).to include(30, 17) }
  end
end
