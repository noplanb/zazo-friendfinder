require 'rails_helper'

RSpec.describe Score::Criterias::ContactOfUsers do
  let(:contact) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new contact }
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
          FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile,   value: mobile)]
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
    let!(:contact_1) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_email, value: email), FactoryGirl.create(:vector_mobile, value: mobile)] }
    let!(:contact_2) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: mobile)] }
    let!(:subject) { instance.save }
    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'contact_of_users' }
    it { expect(subject.persisted?).to be true }

    it { expect(contact.reload.vectors.mobile.first.additions).to eq ({ 'users_with_contact' => [contact_1.owner, contact_2.owner] }) }
    it { expect(contact.reload.vectors.email.first.additions).to eq ({ 'users_with_contact' => [contact_1.owner] }) }
    it { expect(contact.reload.vectors.facebook.first.additions).to be_nil }
  end
end
