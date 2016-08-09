require 'rails_helper'

RSpec.describe Contact::Add do
  let(:vector) { FactoryGirl.create(:vector_mobile, value: '+16502453537') }
  let(:contact) do
    FactoryGirl.create(:contact,
      first_name: 'David',
      last_name: 'Miller',
      owner_mkey: 'GBAHb0482YxlJ0kYwbIS',
      additions: additions,
      vectors: [vector])
  end
  let(:instance) { described_class.new(contact, caller: caller) }
  let(:caller) { :web_client }

  describe '#do' do
    subject { instance.do }

    before do |example|
      subject unless example.metadata[:skip_before]
    end

    context 'when not added', vcr: { cassette: 'when_not_added' } do
      let(:additions) { {} }

      include_examples 'contact is added specs'

      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to receive(:emit).with(%w(contact added), Hash)
        subject
      end

      it 'has specific status', :skip_before do
        is_expected.to eq(status: :queued)
      end

      context 'when called is api' do
        let(:caller) { :api }

        it 'has specific status', :skip_before do
          expect(subject[:status]).to eq(:added)
        end
      end
    end

    context 'when already added' do
      let(:additions) { { added_by_owner: true } }

      include_examples 'contact is added specs'

      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to_not receive(:emit)
        subject
      end

      it 'should have specific status', :skip_before do
        is_expected.to eq(status: :already_added)
      end

      context 'when called is api' do
        let(:caller) { :api }

        it 'has specific status', :skip_before do
          expect(subject[:status]).to eq(:already_added)
        end
      end
    end

    context 'when already ignored', vcr: { cassette: 'when_already_ignored' } do
      let(:additions) { { ignored_by_owner: true } }

      include_examples 'contact is added specs'

      it 'should dispatch an event', :skip_before do
        expect(Zazo::Tool::EventDispatcher).to receive(:emit).with(%w(contact added), Hash)
        subject
      end

      it 'has specific status', :skip_before do
        is_expected.to eq(status: :queued)
      end

      context 'when called is api' do
        let(:caller) { :api }

        it 'has specific status', :skip_before do
          expect(subject[:status]).to eq(:added)
        end
      end
    end
  end
end
