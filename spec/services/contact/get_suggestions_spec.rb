require 'rails_helper'

RSpec.describe Contact::GetSuggestions do
  let(:user) { FactoryGirl.build :user }
  let(:instance) { described_class.new user }

  describe '#do' do
    let(:vectors_1) {[
      FactoryGirl.create(:vector_mobile_sms_messages_sent),
      FactoryGirl.create(:vector_email),
      FactoryGirl.create(:vector_email)
    ]}
    let(:vectors_2) {[
      FactoryGirl.create(:vector_email),
      FactoryGirl.create(:vector_facebook)
    ]}
    let!(:contact_1) { FactoryGirl.create :contact, owner: user.mkey, vectors: vectors_1, additions: { marked_as_favorite: true } }
    let!(:contact_2) { FactoryGirl.create :contact, owner: user.mkey, vectors: vectors_2, additions: { marked_as_favorite: true } }
    subject { instance.do }

    before do
      Score::CalculationByOwner.new(user.mkey).do
      contact_1.reload
      contact_2.reload
    end

    it do
      suggestions = [
        { first_name: contact_1.first_name, last_name: contact_1.last_name, display_name: "#{contact_1.first_name} #{contact_1.last_name}", zazo_mkey: nil, zazo_id: nil, total_score: contact_1.total_score },
        { first_name: contact_2.first_name, last_name: contact_2.last_name, display_name: "#{contact_2.first_name} #{contact_2.last_name}", zazo_mkey: nil, zazo_id: nil, total_score: contact_2.total_score }
      ]
      is_expected.to eq suggestions
    end
  end
end
