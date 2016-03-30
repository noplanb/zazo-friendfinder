require 'rails_helper'

RSpec.describe Contact::GetSuggestions do
  let(:user) { FactoryGirl.build(:user) }
  let(:instance) { described_class.new(user.mkey) }

  describe '#do' do
    let(:vectors_1) do
      [FactoryGirl.create(:vector_mobile_sms_messages_sent),
       FactoryGirl.create(:vector_email),
       FactoryGirl.create(:vector_email)]
    end
    let(:vectors_2) do
      [FactoryGirl.create(:vector_email),
       FactoryGirl.create(:vector_facebook)]
    end
    let(:vectors_3) { [FactoryGirl.create(:vector_mobile)] }
    let(:vectors_4) { [FactoryGirl.create(:vector_mobile)] }
    let(:vectors_5) { [FactoryGirl.create(:vector_mobile)] }

    let!(:contact_1) { FactoryGirl.create(:contact, owner_mkey: user.mkey, vectors: vectors_1, additions: { marked_as_friend: false, marked_as_favorite: true }) }
    let!(:contact_2) { FactoryGirl.create(:contact, owner_mkey: user.mkey, vectors: vectors_2, additions: { marked_as_friend: false, marked_as_favorite: true }) }
    let!(:contact_3) { FactoryGirl.create(:contact, owner_mkey: user.mkey, vectors: vectors_3, additions: { marked_as_friend: true }) }
    let!(:contact_4) { FactoryGirl.create(:contact, owner_mkey: user.mkey, vectors: vectors_4, additions: { marked_as_friend: false }) }
    let!(:contact_5) { FactoryGirl.create(:contact, owner_mkey: user.mkey, additions: { marked_as_friend: false, ignored_by_owner: true }) }
    let!(:contact_6) { FactoryGirl.create(:contact, owner_mkey: user.mkey, additions: { marked_as_friend: false, added_by_owner: true }) }

    subject { instance.do }

    before do
      Owner.new(user.mkey).contacts_actions.recalculate_scores
      contact_1.reload
      contact_2.reload
      contact_3.reload
      contact_4.reload
      contact_5.reload
      contact_6.reload
    end

    it do
      suggestions = [
        {
          id: contact_1.id,
          first_name: contact_1.first_name,
          last_name: contact_1.last_name,
          display_name: "#{contact_1.first_name} #{contact_1.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_1.total_score
        }, {
          id: contact_2.id,
          first_name: contact_2.first_name,
          last_name: contact_2.last_name,
          display_name: "#{contact_2.first_name} #{contact_2.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_2.total_score
        }, {
          id: contact_4.id,
          first_name: contact_4.first_name,
          last_name: contact_4.last_name,
          display_name: "#{contact_4.first_name} #{contact_4.last_name}",
          zazo_mkey: nil,
          zazo_id: nil,
          total_score: contact_4.total_score
        }
      ]
      is_expected.to eq suggestions
    end
  end
end
