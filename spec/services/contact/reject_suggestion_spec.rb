require 'rails_helper'

RSpec.describe Contact::RejectSuggestion do
  let(:user) { FactoryGirl.build :user }
  let(:instance) { described_class.new user, params }

  let(:contact_1) { FactoryGirl.create :contact, owner: user.mkey }
  let(:contact_2) { FactoryGirl.create :contact, owner: user.mkey }

  describe '#do' do
    let(:params) { { 'rejected' => [contact_1.id, contact_2.id] } }
    let!(:subject) { instance.do }
    before { [contact_1, contact_2].each &:reload }

    it { is_expected.to eq true }
    it { expect(contact_1.additions).to eq({ 'rejected_by_owner' => true }) }
    it { expect(contact_2.additions).to eq({ 'rejected_by_owner' => true }) }
  end

  describe 'validations' do
    context 'raw_params' do
      let!(:subject) { instance.do }

      context 'raw_params[\'rejected\'] must be type of Array' do
        let(:params) { { 'rejected' => 'some string' } }

        it { is_expected.to eq false }
        it { expect(instance.errors).to eq({ raw_params: ['raw_params[\'rejected\'] must be type of Array'] }) }
      end

      context 'raw_params must be type of Hash' do
        let(:params) { 'some string' }

        it { is_expected.to eq false }
        it { expect(instance.errors).to eq({ raw_params: ['raw_params must be type of Hash'] }) }
      end

      context 'raw_params must contain correct id\'s' do
        let(:params) { { 'rejected' => [contact_1.id, 1982] } }

        it { is_expected.to eq false }
        it { expect(instance.errors).to eq({ raw_params_id: ['contact with id=1982 is not exist'] }) }
      end
    end
  end
end
