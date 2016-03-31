require 'rails_helper'

RSpec.describe Owner::Extensions::ContactsActions, type: :model do
  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:owner) { Owner.new(owner_mkey) }
  let(:instance) { Owner.new(owner_mkey).contacts_actions }

  describe '#find_contact_and_update_info' do
    let(:mobile) { '+16502453537' }
    let(:email) { 'admin@google.com' }

    let!(:contact_1) do
      FactoryGirl.create(:contact, owner_mkey: owner_mkey,
                         vectors: [FactoryGirl.create(:vector_mobile, value: mobile)])
    end
    let!(:contact_2) do
      FactoryGirl.create(:contact, owner_mkey: owner_mkey,
                         vectors: [FactoryGirl.create(:vector_email, value: email)])
    end

    subject { instance.find_contact_and_update_info }

    before do
      subject
      contact_1.reload
      contact_2.reload
    end

    context 'existing user' do
      it { expect(contact_1.zazo_id).to eq 1 }
      it { expect(contact_1.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'nonexistent user' do
      it { expect(contact_2.zazo_id).to be_nil }
      it { expect(contact_2.zazo_mkey).to be_nil }
    end
  end

  describe '#recalculate_scores' do
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

    let!(:subject) { instance.recalculate_scores }

    it { is_expected.to be true }
    it { expect(owner.contacts.count).to eq 2 }
    it { expect(owner.contacts.map(&:total_score)).to include(75, 53) }
  end
end
