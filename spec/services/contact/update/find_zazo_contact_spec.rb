require 'rails_helper'

RSpec.describe Contact::Update::FindZazoContact do
  let(:owner_mkey) { 'xxxxxxxxxxxxxx' }
  let(:contact) { create(:contact, owner_mkey: owner_mkey, vectors: vectors) }
  let(:instance) { described_class.new(contact) }
  let(:mobile_by_friend) { '+16502453537' }
  let(:mobile_by_not_friend) { '+16502453559' }
  let(:mobile_by_nonexistent) { '+79999999999' }

  describe '#do' do
    def mobile_vectors(*phones)
      phones.map { |p| build(:vector_mobile, value: p) }
    end

    before do
      instance.do
      contact.reload
    end

    context 'by mobile', vcr: { cassette: 'by_mobile' } do
      let(:vectors) { mobile_vectors(mobile_by_nonexistent, mobile_by_not_friend) }

      it { expect(contact.zazo_id).to eq(2) }
      it { expect(contact.zazo_mkey).to eq('oRXc4Q9pIkTZXYDtQka6') }
    end

    context 'by mobile and friendship', vcr: { cassette: 'by_mobile_and_friendship' } do
      let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
      let(:vectors) { mobile_vectors(mobile_by_not_friend, mobile_by_nonexistent, mobile_by_friend) }

      it { expect(contact.zazo_id).to eq(1) }
      it { expect(contact.zazo_mkey).to eq('7qdanSEmctZ2jPnYA0a1') }
    end

    context 'for nonexistent user', vcr: { cassette: 'nonexistent_user' } do
      let(:vectors) { mobile_vectors(mobile_by_nonexistent) }

      it { expect(contact.zazo_id).to be_nil }
      it { expect(contact.zazo_mkey).to be_nil }
    end
  end
end
