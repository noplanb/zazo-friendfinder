require 'rails_helper'

RSpec.describe Contact::Add do
  let(:contact) { FactoryGirl.create(:contact, additions: additions) }
  let(:instance) { described_class.new(contact) }

  describe '#do' do
    before { instance.do }

    context 'when not added' do
      let(:additions) { {} }

      include_examples 'contact is added specs'
    end

    context 'when already added' do
      let(:additions) { { added_by_owner: true } }

      include_examples 'contact is added specs'
    end

    context 'when already ignored' do
      let(:additions) { { ignored_by_owner: true } }

      include_examples 'contact is added specs'
    end
  end
end
