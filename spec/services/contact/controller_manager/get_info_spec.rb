require 'rails_helper'

RSpec.describe Contact::ControllerManager::GetInfo do
  let(:user) { FactoryGirl.build(:user) }
  let(:instance) { described_class.new(user.mkey, params) }

  let(:contact_1) { FactoryGirl.create(:contact, owner_mkey: user.mkey) }
  let(:contact_2) { FactoryGirl.create(:contact, owner_mkey: 'xxxxxxxxxxxx') }

  describe '#do' do
    subject { instance.do }

    before { subject }

    context 'when contact is exist' do
      let(:params) { { 'id' => contact_1.id } }

      it { is_expected.to be true }
      it { expect(instance.errors).to eq Hash.new }
      it do
        expected = {
          id: contact_1.id,
          first_name: contact_1.first_name,
          last_name: contact_1.last_name,
          display_name: contact_1.display_name,
          zazo_mkey: nil, zazo_id: nil,
          total_score: 0, vectors: []
        }
        expect(instance.data).to eq data: expected
      end
    end

    context 'when contact is not exist' do
      let(:params) { { 'id' => 123 } }

      it { is_expected.to be false }
      it { expect(instance.errors).to eq contact_id: ['not found by id=123'] }
      it { expect(instance.data).to eq Hash.new }
    end

    context 'when contact is not belongs to owner' do
      let(:params) { { 'id' => contact_2.id } }

      it { is_expected.to be false }
      it { expect(instance.errors).to eq contact_id: ['not belongs to owner'] }
      it { expect(instance.data).to eq Hash.new }
    end
  end
end
