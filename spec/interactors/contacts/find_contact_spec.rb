require 'rails_helper'

RSpec.describe Contacts::FindContact do
  let(:owner) { Owner.new('GBAHb0482YxlJ0kYwbIS') }

  describe '.run' do
    subject do
      described_class.run(id: id, owner: owner)
    end

    context 'when contact is exist' do
      let(:id) { create(:contact, owner_mkey: 'GBAHb0482YxlJ0kYwbIS').id }

      it { expect(subject.valid?).to be(true) }
      it { expect(subject.errors.messages).to eq({}) }
      it { expect(subject.result.id).to eq(id) }
    end

    context 'when contact is not found by id' do
      let(:id) { 1248 }

      it { expect(subject.valid?).to be(false) }
      it { expect(subject.errors.messages).to eq(id: ['contact not found by id=1248']) }
    end

    context 'when user is not owner of contact' do
      let(:id) { create(:contact, owner_mkey: 'xxxxxxxxxxxx').id }

      it { expect(subject.valid?).to be(false) }
      it { expect(subject.errors.messages).to eq(id: ["current user is not owner of contact with id=#{id}"]) }
    end
  end
end
