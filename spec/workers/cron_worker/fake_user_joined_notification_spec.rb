require 'rails_helper'

RSpec.describe CronWorker::FakeUserJoinedNotification do
  def create_contact(owner_mkey, total_score, client_mobile, additions = {})
    contact = FactoryGirl.create(:contact, owner_mkey: owner_mkey, total_score: total_score, additions: additions)
    FactoryGirl.create(:vector_mobile, contact: contact, value: client_mobile)
    contact
  end

  let!(:contact_11) { create_contact('xxxxxxxxx_1', 5, '+380951035160', 'marked_as_friend' => false) }
  let!(:contact_12) { create_contact('xxxxxxxxx_1', 4, '+380951035161', 'marked_as_friend' => false) }
  let!(:contact_21) { create_contact('xxxxxxxxx_2', 5, '+380508891332', 'marked_as_friend' => false) }
  let!(:contact_22) { create_contact('xxxxxxxxx_2', 6, '+380951035162', 'marked_as_friend' => false) }
  let!(:contact_31) { create_contact('xxxxxxxxx_3', 4, '+380951035163', 'marked_as_friend' => false) }
  let!(:contact_41) { create_contact('xxxxxxxxx_4', 4, '+380951035164', 'marked_as_friend' => false) }
  let!(:contact_51) { create_contact('xxxxxxxxx_4', 4, '+380951035165', 'marked_as_friend' => true) }
  let!(:contact_61) { create_contact('xxxxxxxxx_4', 4, '+380951035166', 'marked_as_friend' => true) }
  let!(:contact_71) { create_contact('xxxxxxxxx_4', 4, '+380951035167', 'marked_as_friend' => true) }

  before do
    allow_any_instance_of(Notification::Send).to receive(:do).and_return(true)
  end

  describe '.perform' do
    before do
      FactoryGirl.create(:notification, status: 'added', contact: contact_41)
      described_class.perform(force: true)
    end

    it { expect(Notification.count).to eq(7) }
    it { expect(Notification.distinct.pluck(:nkey).count).to eq(4) }
    it do
      expected = [contact_11.id, contact_22.id, contact_31.id, contact_41.id]
      expect(Notification.distinct.pluck(:contact_id)).to match_array(expected)
    end
  end
end


