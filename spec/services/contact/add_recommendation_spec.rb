require 'rails_helper'

RSpec.describe Contact::AddRecommendation do
  let(:user) { FactoryGirl.build :user }
  let(:instance) { described_class.new user, params }

  let(:recommended_contact) { FactoryGirl.build :user }
  let(:recommended_to_1) { FactoryGirl.build(:user) }
  let(:recommended_to_2) { FactoryGirl.build(:user) }

  let!(:contact_1) { FactoryGirl.create :contact, owner: recommended_to_1.mkey }
  let!(:contact_2) { FactoryGirl.create :contact, owner: recommended_to_2.mkey }

  describe '#do' do
    context 'with correct params when contact exist' do
      let(:recommended_to) { FactoryGirl.build(:user) }
      let(:params) do
        { 'contact_mkey' => recommended_contact.mkey,
          'to_mkeys' => [recommended_to.mkey] }
      end
      let!(:contact) { FactoryGirl.create :contact, owner: recommended_to.mkey, zazo_mkey: recommended_contact.mkey }
      let(:contacts) { Contact.by_owner(recommended_to.mkey) }
      let!(:subject) { instance.do }

      it { is_expected.to eq true }
      it { expect(contacts.size).to eq 1 }
      it { expect(contacts.first.zazo_mkey).to eq recommended_contact.mkey }
    end

    context 'with correct params when contact not exist' do
      let(:params) do
        { 'contact_mkey' => recommended_contact.mkey,
          'to_mkeys' => [recommended_to_1.mkey, recommended_to_2.mkey] }
      end
      let!(:subject) { instance.do }
      let(:contact_by_1_last) { Contact.by_owner(recommended_to_1.mkey).last }
      let(:contact_by_2_last) { Contact.by_owner(recommended_to_2.mkey).last }

      it { is_expected.to eq true }
      it { expect(contact_by_1_last.zazo_mkey).to eq recommended_contact.mkey }
      it { expect(contact_by_2_last.zazo_mkey).to eq recommended_contact.mkey }
      it { expect(contact_by_1_last.additions['recommended_by']).to eq [user.mkey] }
      it { expect(contact_by_2_last.additions['recommended_by']).to eq [user.mkey] }
    end
  end

  describe 'validations' do
    it 'add validation specs'
  end
end
