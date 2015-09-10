require 'rails_helper'

RSpec.describe Score::Criterias::IsContactRegisteredOnZazo do
  let(:connection) { FactoryGirl.create :contact, attributes }
  let(:instance) { described_class.new connection }

  describe '#calculate_with_ratio' do
    subject { instance.calculate_with_ratio }

    context 'when contact is zazo user' do
      let(:attributes) { { zazo_mkey: 'xxxxxxxxx', zazo_id: 1 } }

      it { is_expected.to eq 4 }
    end

    context 'when contact is not zazo user' do
      let(:attributes) { {} }

      it { is_expected.to eq 0 }
    end
  end

  describe '#save' do
    let(:attributes) { { zazo_mkey: 'xxxxxxxxx', zazo_id: 1 } }
    subject { instance.save }

    it { is_expected.to be_valid }
    it { expect(subject.name).to eq 'is_contact_registered_on_zazo' }
    it { expect(subject.persisted?).to be true }
  end
end
