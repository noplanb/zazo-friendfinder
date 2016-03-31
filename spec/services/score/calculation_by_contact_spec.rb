require 'rails_helper'

RSpec.describe Score::CalculationByContact do
  let(:owner_mkey) { 'xxxxxxxxxxxx' }
  let(:contact) { FactoryGirl.create(:contact, owner_mkey: owner_mkey, vectors: vectors, additions: { marked_as_favorite: true }) }
  let(:instance) { described_class.new(contact) }

  describe '#do' do
    let(:vectors) do
      [FactoryGirl.create(:vector_mobile, additions: { sms_messages_sent: 12 }),
       FactoryGirl.create(:vector_email)]
    end

    before do
      FactoryGirl.create(:contact, vectors: [FactoryGirl.create(:vector_email, value: vectors.last.value)])
    end

    let!(:subject) { instance.do }

    it { is_expected.to be true }
    it { expect(Score.all.size).to eq 10 }
    it { expect(contact.reload.total_score).to eq 79 }
  end
end
