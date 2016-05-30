require 'rails_helper'

RSpec.describe Contacts::GetContactData do
  let(:contact) { FactoryGirl.create(:contact) }

  describe '.run' do
    subject { described_class.run(contact: contact) }

    it do
      expected = {
        id: contact.id,
        first_name: contact.first_name,
        last_name: contact.last_name,
        display_name: contact.display_name,
        zazo_mkey: nil, zazo_id: nil,
        total_score: 0, vectors: []
      }
      expect(subject.result).to eq(expected)
    end
  end
end
