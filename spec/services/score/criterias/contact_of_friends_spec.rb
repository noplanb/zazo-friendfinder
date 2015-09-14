require 'rails_helper'

RSpec.describe Score::Criterias::ContactOfFriends do
  use_vcr_cassette 'contact/get_zazo_friends_GBAHb0482YxlJ0kYwbIS', api_base_urls

  let(:owner) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:friend_1) { '0DAQEVtmNKQiW6aoQrvo' }
  let(:friend_2) { '7qdanSEmctZ2jPnYA0a1' }

  let(:contact) { FactoryGirl.create :contact, owner: owner, vectors: vectors }
  let(:instance) { described_class.new contact }

  let(:email) { 'elfishawy.sani@gmail.com' }
  let(:mobile) { '+16502453537' }
  let(:vectors) do
    [ FactoryGirl.create(:vector_email, value: email),
      FactoryGirl.create(:vector_mobile, value: mobile) ]
  end

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'by two friends overlap' do
      before do
        FactoryGirl.create :contact, owner: friend_1, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)]
        FactoryGirl.create :contact, owner: friend_2, vectors: [FactoryGirl.create(:vector_email, value: email)]
        FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email, value: email)]
      end

      it { is_expected.to eq 16 }
    end

    context 'by one friend overlap' do
      before do
        FactoryGirl.create :contact, owner: friend_1, vectors: [FactoryGirl.create(:vector_mobile, value: mobile), FactoryGirl.create(:vector_email, value: email)]
        FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email, value: email)]
      end

      it { is_expected.to eq 8 }
    end

    context 'without friends overlap' do
      before do
        FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)]
        FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email, value: email)]
      end

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let!(:subject) { instance.save }
    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'contact_of_friends' }
    it { expect(subject.persisted?).to be true }
  end
end
