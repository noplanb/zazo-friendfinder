require 'rails_helper'

RSpec.describe Contacts::HandleAction do
  let(:contact) { create(:contact) }

  describe '.run' do
    subject do
      described_class.run(contact: contact, caller: :api, action: action).result
    end

    before do
      allow_any_instance_of(Contact::Add).to receive(:invite_contact).and_return(status: :added)
    end

    context 'add action' do
      let(:action) { 'add' }

      it { is_expected.to eq(status: :added) }
      it do
        subject
        expect(contact.reload.additions).to eq('added_by_owner' => true)
      end
    end

    context 'ignore action' do
      let(:action) { 'ignore' }

      it { is_expected.to eq(status: :ignored) }
      it do
        subject
        expect(contact.reload.additions).to eq('ignored_by_owner' => true)
      end
    end
  end
end
