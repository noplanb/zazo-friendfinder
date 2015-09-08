require 'rails_helper'

RSpec.describe Score::Criterias::OthersHavingThisContact do
  let(:connection) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new connection }
  let(:email) { 'elfishawy.sani@gmail.com' }
  let(:mobile) { '+16502453537' }
  let(:vectors) do
    [ FactoryGirl.create(:vector_email, value: email),
      FactoryGirl.create(:vector_mobile, value: mobile),
      FactoryGirl.create(:vector_facebook, value: email) ]
  end

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'several others have this contact' do
      context 'by one vector overlap' do
        before do
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email,    value: email)]
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_facebook, value: email)]
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email,    value: email), FactoryGirl.create(:vector_facebook, value: email)]
        end

        it { is_expected.to eq 9 }
      end

      context 'by two vectors overlap' do
        before do
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email,    value: email), FactoryGirl.create(:vector_mobile, value: mobile)]
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_facebook, value: email), FactoryGirl.create(:vector_mobile, value: mobile)]
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_facebook, value: email)]
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile,   value: email)]
        end

        it { is_expected.to eq 12 }
      end
    end

    context 'one other has this contact' do
      context 'by one vector overlap' do
        before do
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_facebook, value: email)]
        end

        it { is_expected.to eq 3 }
      end

      context 'by two vectors overlap' do
        before do
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_facebook, value: email), FactoryGirl.create(:vector_mobile, value: mobile)]
        end

        it { is_expected.to eq 3 }
      end
    end

    context 'no one has this contact' do
      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'others_having_this_contact' }
    it { expect(subject.persisted?).to be true }
  end
end
