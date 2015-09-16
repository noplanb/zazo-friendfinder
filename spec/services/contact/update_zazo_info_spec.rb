require 'rails_helper'

RSpec.describe Contact::UpdateZazoInfo do
  let(:contact) { FactoryGirl.create :contact, zazo_mkey: mkey }
  let(:instance) { described_class.new contact }
  let(:mkey) { 'GBAHb0482YxlJ0kYwbIS' }

  describe '#do' do
    use_vcr_cassette 'contact/update_zazo_contact_by_GBAHb0482YxlJ0kYwbIS', api_base_urls
    subject { contact.reload }
    before { instance.do }

    it { expect(subject.first_name).to eq 'Ivan' }
    it { expect(subject.last_name).to eq 'Kornilov' }
    it { expect(subject.zazo_id).to eq 3686 }
    it { expect(subject.zazo_mkey).to eq mkey }
  end
end
