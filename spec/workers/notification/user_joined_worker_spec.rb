require 'rails_helper'

RSpec.describe Notification::UserJoinedWorker do
  let!(:contact_1) do
    FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: '+380930127802'),
                                           FactoryGirl.create(:vector_mobile, value: '+380951035160')]
  end
  let!(:contact_2) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: '+380951035160')] }
  let!(:contact_3) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: '+380508891332')] }
  let!(:contact_4) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: '+380951035161')] }
  let!(:contact_4) { FactoryGirl.create :contact, vectors: [FactoryGirl.create(:vector_mobile, value: '+380951035160')] }
  let(:recently_joined_users) do
    [
      { id: 1,
        mkey: 'xxxxxxxxxxxx',
        mobile_number: '+380930127802',
        first_name: 'Sergei',
        last_name: 'Mavrodi',
        emails: nil,
        status: 'invited' },
      { id: 2,
        mkey: 'xxxxxxxxxxxx',
        mobile_number: '+380951035160',
        first_name: 'Anton',
        last_name: 'Chekhov',
        emails: nil,
        status: 'registered' }
    ].map { |data| data.stringify_keys }
  end

  before do
    allow_any_instance_of(Notification::Send).to receive(:do).and_return true
  end

  describe '.perform' do
    subject { described_class.perform }
    before do
      allow(described_class).to receive(:recently_joined_users).and_return recently_joined_users
    end

    context 'when one contact is unsubscribed' do
      before do
        FactoryGirl.create :notification, status: 'unsubscribed', contact: contact_4
        subject
      end

      it { expect(Notification.count).to eq 5 }
      it { expect(Notification.distinct.pluck(:nkey).count).to eq 3 }
    end

    context 'when all contacts is subscribed' do
      before { subject }

      it { expect(Notification.count).to eq 6 }
      it { expect(Notification.distinct.pluck(:nkey).count).to eq 3 }
    end
  end
end
