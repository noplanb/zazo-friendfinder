require 'rails_helper'

RSpec.describe Contact::Update::UpdateZazoInfo do
  let(:contact) { FactoryGirl.create(:contact, owner_mkey: owner_mkey, zazo_mkey: zazo_mkey) }
  let(:instance) { described_class.new contact }
  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:zazo_mkey) { 'GBAHb0482YxlJ0kYwbIS' }

  describe '#do' do
    subject { contact.reload }
    before { instance.do }

    it { expect(subject.first_name).to eq 'Ivan' }
    it { expect(subject.last_name).to eq 'Kornilov' }
    it { expect(subject.zazo_id).to eq 3686 }
    it { expect(subject.zazo_mkey).to eq zazo_mkey }

    describe 'additions[marked_as_friend]' do
      context 'true' do
        let(:owner_mkey) { '7qdanSEmctZ2jPnYA0a1' }
        it { expect(subject.additions['marked_as_friend']).to eq true }
      end

      context 'false' do
        it { expect(subject.additions['marked_as_friend']).to eq false }
      end
    end
  end
end
