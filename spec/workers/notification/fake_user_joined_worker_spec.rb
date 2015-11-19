require 'rails_helper'

RSpec.describe Notification::FakeUserJoinedWorker do
  def create_contact(owner_mkey, total_score, client_mobile)
    contact = FactoryGirl.create :contact, owner_mkey: owner_mkey, total_score: total_score
    FactoryGirl.create :vector_mobile, contact: contact, value: client_mobile
    contact
  end

  let!(:contact_11) { create_contact 'xxxxxxxxx_1', 5, '+380951035160' }
  let!(:contact_12) { create_contact 'xxxxxxxxx_1', 4, '+380951035161' }
  let!(:contact_21) { create_contact 'xxxxxxxxx_2', 5, '+380508891332' }
  let!(:contact_22) { create_contact 'xxxxxxxxx_2', 6, '+380951035162' }
  let!(:contact_31) { create_contact 'xxxxxxxxx_3', 4, '+380951035163' }
  let!(:contact_41) { create_contact 'xxxxxxxxx_4', 4, '+380951035164' }

  describe '.perform' do
    subject { described_class.perform }
    before do
      FactoryGirl.create :template, category: 'fake_user_joined', kind: 'mobile_notification'
      FactoryGirl.create :template, category: 'fake_user_joined', kind: 'email'
      FactoryGirl.create :notification, status: 'added', contact: contact_41
    end

    context 'when one contact is unsubscribed' do
      before do
        FactoryGirl.create :notification, status: 'unsubscribed', contact: contact_12
        subject
      end
      it { expect(Notification.count).to eq 6 }
      it { expect(Notification.distinct.pluck(:nkey).count).to eq 4 }
      it { expect(Notification.where.not(template: nil).count).to eq 4 }
      it { expect(Notification.where(status: nil).count).to eq 4 }
    end

    context 'when all contacts is subscribed' do
      before { subject }
      it { expect(Notification.count).to eq 7 }
      it { expect(Notification.distinct.pluck(:nkey).count).to eq 4 }
      it { expect(Notification.where.not(template: nil).count).to eq 6 }
      it do
        expected = [contact_11.id, contact_22.id, contact_31.id, contact_41.id]
        expect(Notification.distinct.pluck(:contact_id)).to match_array expected
      end
    end
  end
end
