require 'rails_helper'

RSpec.describe Contacts::RecommendContact do
  let(:owner) { Owner.new(FactoryGirl.build(:user).mkey) }

  let(:contact_to_recommend) { FactoryGirl.build(:user) }
  let(:recommended_to_1) { FactoryGirl.build(:user) }
  let(:recommended_to_2) { FactoryGirl.build(:user) }

  describe '.run' do
    subject do
      described_class.run(owner: owner,
        recommendations: { contact_mkey: contact_to_recommend.mkey, to_mkeys: to_mkeys })
    end

    context 'when contact is exist' do
      let(:to_mkeys) { [recommended_to_1.mkey] }
      let(:contact) { Owner.new(recommended_to_1.mkey).contacts.first }

      before do
        FactoryGirl.create(:contact,
          owner_mkey: recommended_to_1.mkey, zazo_mkey: contact_to_recommend.mkey)
      end

      it { expect(subject.valid?).to be(true) }
      it { subject; expect(contact.zazo_mkey).to eq(contact_to_recommend.mkey) }
      it { subject; expect(contact.additions['recommended_by']).to eq([owner.mkey]) }
    end

    context 'when contact is not exist' do
      let(:to_mkeys) { [recommended_to_1.mkey, recommended_to_2.mkey] }
      let(:contact_by_1_last) { Owner.new(recommended_to_1.mkey).contacts.last }
      let(:contact_by_2_last) { Owner.new(recommended_to_2.mkey).contacts.last }

      it { expect(subject.valid?).to be(true) }
      it { subject; expect(contact_by_1_last.zazo_mkey).to eq(contact_to_recommend.mkey) }
      it { subject; expect(contact_by_2_last.zazo_mkey).to eq(contact_to_recommend.mkey) }
      it { subject; expect(contact_by_1_last.additions['recommended_by']).to eq([owner.mkey]) }
      it { subject; expect(contact_by_2_last.additions['recommended_by']).to eq([owner.mkey]) }
      it { subject; expect(ResqueWorker::UpdateMkeyDefinedContact).to have_queued(contact_by_1_last.id).in(:update_contacts) }
      it { subject; expect(ResqueWorker::UpdateMkeyDefinedContact).to have_queued(contact_by_2_last.id).in(:update_contacts) }
    end
  end

  describe 'validations' do
    subject { described_class.run({ owner: owner }.merge(recommendations: params)) }

    context 'raw_params' do
      context 'to_mkeys' do
        let(:params) { { contact_mkey: contact_to_recommend.mkey, to_mkeys: 'some string' } }

        it { expect(!!subject.valid?).to be(false) }
        it { expect(subject.errors.messages).to eq(recommendations: ['has an invalid nested value ("to_mkeys" => "some string")']) }
      end

      context 'contact_mkey' do
        let(:params) { { to_mkeys: [] } }

        it { expect(!!subject.valid?).to be(false) }
        it { expect(subject.errors.messages).to eq(recommendations: ['has an invalid nested value ("contact_mkey" => nil)']) }
      end

      context 'recommendations' do
        let(:params) { 'some string' }

        it { expect(!!subject.valid?).to be(false) }
        it { expect(subject.errors.messages).to eq(recommendations: ['is not a valid hash']) }
      end
    end
  end
end
