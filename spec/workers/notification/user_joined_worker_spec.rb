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

  describe '.perform' do
    notification_nkeys_count    = -> { Notification.distinct.pluck(:nkey).count }
    notification_with_templates = -> { Notification.where.not(template: nil).count }

    subject { described_class.perform }
    before do
      allow(described_class).to receive(:recently_joined_users).and_return recently_joined_users
    end

    context 'when all templates persisted' do
      before do
        FactoryGirl.create :template, category: 'user_joined', kind: 'mobile_notification'
        FactoryGirl.create :template, category: 'user_joined', kind: 'email'
      end

      context 'when one contact is unsubscribed' do
        before do
          FactoryGirl.create :notification, status: 'unsubscribed', contact: contact_4
          subject
        end

        it { expect(Notification.count).to eq 5 }
        it { expect(notification_nkeys_count.call).to eq 3 }
        it { expect(notification_with_templates.call).to eq 4 }
      end

      context 'when all contacts is subscribed' do
        before { subject }
        it { expect(Notification.count).to eq 6 }
        it { expect(notification_nkeys_count.call).to eq 3 }
        it { expect(notification_with_templates.call).to eq 6 }
      end
    end

    context 'when not all templates persisted' do
      before do
        FactoryGirl.create :template, category: 'user_joined', kind: 'email'
        subject
      end

      it { expect(Notification.count).to eq 6 }
      it { expect(notification_nkeys_count.call).to eq 3 }
      it { expect(notification_with_templates.call).to eq 3 }
    end
  end
end
