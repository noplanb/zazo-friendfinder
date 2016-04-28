require 'rails_helper'

RSpec.describe Api::Contact::Ignore do
  let(:user) { FactoryGirl.build(:user) }
  let(:instance) { described_class.new(user.mkey, params) }
  let(:contact) { FactoryGirl.create(:contact, owner_mkey: user.mkey) }

  let!(:subject) { instance.do }

  describe '#do' do
    let(:params) { { 'id' => contact.id.to_s } }
    before { contact.reload }

    it { is_expected.to eq true }
    it { expect(contact.additions).to eq 'ignored_by_owner' => true }
  end

  describe 'validations' do
    context 'raw_params' do
      context 'raw_params must be type of Hash' do
        let(:params) { 'some string' }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(raw_params: ['raw_params must be type of Hash']) }
      end

      context 'raw_params must contain id attribute' do
        let(:params) { { 'not_id' => 'string' } }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(raw_params: ['raw_params[\'id\'] must be type of String']) }
      end

      context 'raw_params must contain correct id' do
        let(:params) { { 'id' => '1982' } }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(contact_id: ['not found by id=1982']) }
      end
    end
  end
end
