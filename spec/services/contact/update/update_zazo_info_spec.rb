require 'rails_helper'

RSpec.describe Contact::Update::UpdateZazoInfo do
  let(:contact) { create(:contact, owner_mkey: owner_mkey, zazo_mkey: zazo_mkey) }
  let(:instance) { described_class.new(contact) }
  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:zazo_mkey) { 'GBAHb0482YxlJ0kYwbIS' }

  describe '#do', vcr: { cassette: 'not_marked_as_friend' } do
    before do
      instance.do
      contact.reload
    end

    it { expect(contact.first_name).to eq('Ivan') }
    it { expect(contact.last_name).to eq('Kornilov') }
    it { expect(contact.zazo_id).to eq(3686) }
    it { expect(contact.zazo_mkey).to eq(zazo_mkey) }

    describe 'additions[marked_as_friend]' do
      context 'true', vcr: { cassette: 'marked_as_friend' } do
        let(:owner_mkey) { '7qdanSEmctZ2jPnYA0a1' }

        it { expect(contact.additions['marked_as_friend']).to eq(true) }
      end

      context 'false' do
        it { expect(contact.additions['marked_as_friend']).to eq(false) }
      end
    end
  end
end
