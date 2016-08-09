require 'rails_helper'

RSpec.describe Contacts::GetSuggestions do
  let(:owner) { Owner.new('GBAHb0482YxlJ0kYwbIS') }

  describe '.run' do
    let(:vectors_1) { [create(:vector_mobile_sms_messages_sent), create(:vector_email), create(:vector_email)] }
    let(:vectors_2) { [create(:vector_email), create(:vector_facebook)] }
    let(:vectors_3) { [create(:vector_mobile)] }
    let(:vectors_4) { [create(:vector_mobile)] }
    let(:vectors_5) { [create(:vector_mobile)] }

    let!(:contact_1) { create(:contact, owner_mkey: owner.mkey, vectors: vectors_1, additions: { marked_as_friend: false, marked_as_favorite: true }) }
    let!(:contact_2) { create(:contact, owner_mkey: owner.mkey, vectors: vectors_2, additions: { marked_as_friend: false, marked_as_favorite: true }) }
    let!(:contact_3) { create(:contact, owner_mkey: owner.mkey, vectors: vectors_3, additions: { marked_as_friend: true }) }
    let!(:contact_4) { create(:contact, owner_mkey: owner.mkey, vectors: vectors_4, additions: { marked_as_friend: false }) }
    let!(:contact_5) { create(:contact, owner_mkey: owner.mkey, additions: { marked_as_friend: false, ignored_by_owner: true }) }
    let!(:contact_6) { create(:contact, owner_mkey: owner.mkey, additions: { marked_as_friend: false, added_by_owner: true }) }

    subject { described_class.run(owner: owner).result }

    before do
      owner.contacts_actions.recalculate_scores
      (1..6).each { |n| send("contact_#{n}").reload }
    end

    it do
      expected = [
        {
          id: contact_1.id,
          first_name: contact_1.first_name,
          last_name: contact_1.last_name,
          display_name: "#{contact_1.first_name} #{contact_1.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_1.total_score,
          phone_numbers: [vectors_1.first.value]
        }, {
          id: contact_2.id,
          first_name: contact_2.first_name,
          last_name: contact_2.last_name,
          display_name: "#{contact_2.first_name} #{contact_2.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_2.total_score,
          phone_numbers: []
        }, {
          id: contact_4.id,
          first_name: contact_4.first_name,
          last_name: contact_4.last_name,
          display_name: "#{contact_4.first_name} #{contact_4.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_4.total_score,
          phone_numbers: [vectors_4.first.value]
        }
      ]
      is_expected.to eq(expected)
    end
  end
end
