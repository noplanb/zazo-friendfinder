require 'rails_helper'

RSpec.describe Score::CalculationByOwner do
  use_vcr_cassette 'contact/get_zazo_friends_for_nonexistent_user', api_base_urls

  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:instance) { described_class.new owner_mkey }

  describe '#do' do
    before do
      # first owner's contact
      vectors = [
        FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 12 }),
        FactoryGirl.create(:vector_email)
      ]
      FactoryGirl.create :contact, owner_mkey: owner_mkey, vectors: vectors, additions: { marked_as_favorite: true }

      # second owner's contact
      vectors = [FactoryGirl.create(:vector_mobile)]
      FactoryGirl.create :contact, owner_mkey: owner_mkey, vectors: vectors, additions: { marked_as_favorite: true }

      # non owner's contact
      vectors = [FactoryGirl.create(:vector_mobile, value: vectors.last.value)]
      FactoryGirl.create :contact, vectors: vectors
    end
    let!(:subject) { instance.do }

    it { is_expected.to be true }
    it { expect(Contact.by_owner(owner_mkey).count).to eq 2 }
    it { expect(Contact.by_owner(owner_mkey).map(&:total_score)).to include(75, 53) }
  end
end
