require 'rails_helper'

RSpec.describe Score::Criteria::ContactOfUsers do
  let(:contact) { create :contact, vectors: vectors }
  let(:instance) { described_class.new contact }
  let(:email) { 'elfishawy.sani@gmail.com' }
  let(:mobile) { '+16502453537' }
  let(:vectors) do
    [ create(:vector_email, value: email),
      create(:vector_mobile, value: mobile),
      create(:vector_facebook, value: email) ]
  end

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'several others have this contact' do
      context 'by one vector overlap' do
        before do
          create :contact, vectors: [create(:vector_email, value: email)]
          create :contact, vectors: [create(:vector_facebook, value: email)]
          create :contact, vectors: [create(:vector_email, value: email), create(:vector_facebook, value: email)]
        end

        it { is_expected.to eq 12 }
      end

      context 'by two vectors overlap' do
        before do
          create :contact, vectors: [create(:vector_email, value: email), create(:vector_mobile, value: mobile)]
          create :contact, vectors: [create(:vector_facebook, value: email), create(:vector_mobile, value: mobile)]
          create :contact, vectors: [create(:vector_facebook, value: email)]
          create :contact, vectors: [create(:vector_mobile, value: mobile)]
        end

        it { is_expected.to eq 16 }
      end
    end

    context 'one other has this contact' do
      context 'by one vector overlap' do
        before do
          create :contact, vectors: [create(:vector_facebook, value: email)]
        end

        it { is_expected.to eq 4 }
      end

      context 'by two vectors overlap' do
        before do
          create :contact, vectors: [create(:vector_facebook, value: email), create(:vector_mobile, value: mobile)]
        end

        it { is_expected.to eq 4 }
      end
    end

    context 'no one has this contact' do
      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let!(:contact_1) { create :contact, vectors: [create(:vector_email, value: email), create(:vector_mobile, value: mobile)] }
    let!(:contact_2) { create :contact, vectors: [create(:vector_mobile, value: mobile)] }
    let!(:subject) { instance.save }
    before { contact.reload }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'contact_of_users' }
    it { expect(subject.persisted?).to be true }
    it { expect(contact.additions['users_with_contact']).to include *[contact_1.owner.mkey, contact_2.owner.mkey] }
  end
end
