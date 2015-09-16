require 'rails_helper'

RSpec.describe Contact::SetZazoIdAndMkey do
  let(:contact) { FactoryGirl.create :contact, vectors: vectors }
  let(:instance) { described_class.new contact }
  let(:mobile) { '+16502453537' }
  let(:email)  { 'elfishawy.sani@gmail.com' }

  describe '#do' do
    subject { contact.reload }

    context 'by mobile' do
      use_vcr_cassette 'contact/set_zazo_id_and_mkey_by_mobile', api_base_urls
      let(:vectors) { [FactoryGirl.create(:vector_mobile, value: mobile)] }
      before { instance.do }

      it { expect(subject.zazo_id).to eq 1 }
      it { expect(subject.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'by email' do
      use_vcr_cassette 'contact/set_zazo_id_and_mkey_by_email', api_base_urls
      let(:vectors) { [FactoryGirl.create(:vector_email, value: email)] }
      before { instance.do }

      it { expect(subject.zazo_id).to eq 1 }
      it { expect(subject.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'by invalid mobile and correct email together' do
      use_vcr_cassette 'contact/set_zazo_id_and_mkey_by_invalid_mobile_and_correct_email', api_base_urls
      let(:vectors) do
        [ FactoryGirl.create(:vector_mobile, value: '+79999999999'),
          FactoryGirl.create(:vector_email, value: email) ]
      end
      before { instance.do }

      it { expect(subject.zazo_id).to eq 1 }
      it { expect(subject.zazo_mkey).to eq '7qdanSEmctZ2jPnYA0a1' }
    end

    context 'for nonexistent user' do
      use_vcr_cassette 'contact/set_zazo_id_and_mkey_for_nonexistent_user', api_base_urls
      let(:vectors) do
        [ FactoryGirl.create(:vector_email,  value: 'admin@google.com'),
          FactoryGirl.create(:vector_mobile, value: '+79999999999') ]
      end
      before { instance.do }

      it { expect(subject.zazo_id).to be_nil }
      it { expect(subject.zazo_mkey).to be_nil }
    end
  end
end
