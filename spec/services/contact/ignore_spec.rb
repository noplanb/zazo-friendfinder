require 'rails_helper'

RSpec.describe Contact::Ignore do
  let(:contact) { create(:contact, additions: additions) }
  let(:instance) { described_class.new(contact) }

  describe '#do' do
    subject { instance.do }

    before do |example|
      subject unless example.metadata[:skip_before]
    end

    context 'when not added/ignored' do
      let(:additions) { {} }

      include_examples 'contact is ignored specs'
      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to receive(:emit).with(%w(contact ignored), Hash)
        subject
      end
      it 'has specific status', :skip_before do
        is_expected.to eq(status: :ignored)
      end
    end

    context 'when already ignored' do
      let(:additions) { { ignored_by_owner: true } }

      include_examples 'contact is ignored specs'
      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to_not receive(:emit)
        subject
      end
      it 'has specific status', :skip_before do
        is_expected.to eq(status: :already_ignored)
      end
    end

    context 'when already added' do
      let(:additions) { { added_by_owner: true } }

      include_examples 'contact is added specs'
      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to_not receive(:emit)
        subject
      end
      it 'has specific status', :skip_before do
        is_expected.to eq(status: :already_added)
      end
    end
  end
end
