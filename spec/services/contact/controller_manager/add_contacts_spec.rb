require 'rails_helper'

RSpec.describe Contact::ControllerManager::AddContacts do
  let(:user) { FactoryGirl.build(:user) }
  let(:instance) { described_class.new(user.mkey, params) }

  let(:contact_1) { FactoryGirl.create(:contact, owner_mkey: user.mkey) }
  let(:contact_2) { FactoryGirl.create(:contact, owner_mkey: user.mkey, additions: { ignored_by_owner: true }) }
  let(:contact_3) { FactoryGirl.create(:contact, owner_mkey: user.mkey, additions: { added_by_owner: true }) }

  subject { instance.do }

  before do
    allow_any_instance_of(Contact::Add).to receive(:invite_contact).and_return(status: :added)
  end

  describe '#do' do
    let(:params) { { 'contacts_ids' => [contact_1.id, contact_2.id, contact_3.id] } }

    before do
      subject
      [contact_1, contact_2, contact_3].each(&:reload)
    end

    it { is_expected.to eq true }
    it { expect(contact_1.additions).to eq('added_by_owner' => true) }
    it { expect(contact_2.additions).to eq('added_by_owner' => true) }
    it { expect(contact_3.additions).to eq('added_by_owner' => true) }
  end

  describe 'validations' do
    context 'raw_params' do
      before { subject }

      context 'raw_params[\'contacts_ids\'] must be type of Array' do
        let(:params) { { 'contacts_ids' => 'some string' } }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(raw_params: ['raw_params[\'contacts_ids\'] must be type of Array']) }
      end

      context 'raw_params must be type of Hash' do
        let(:params) { 'some string' }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(raw_params: ['raw_params must be type of Hash']) }
      end

      context 'raw_params must contain correct id\'s' do
        let(:params) { { 'contacts_ids' => [contact_1.id, 1982] } }

        it { is_expected.to eq(false) }
        it { expect(instance.errors).to eq(contact_id: ['not found by id=1982']) }
      end
    end
  end
end
