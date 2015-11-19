require 'spec_helper'

describe WebClientDecorator do
  let(:contact) { FactoryGirl.create :contact }
  let(:notification) { FactoryGirl.create :notification, contact: contact }
  let(:web_client) { WebClient::ActionHandler.new notification.nkey }
  let(:instance) { described_class.decorate web_client }

  describe '#contact_first_name' do
    it { expect(instance.contact_first_name).to eq contact.first_name }
  end

  describe '#contact_full_name' do
    it { expect(instance.contact_full_name).to eq contact.display_name }
  end

  describe '#another_contacts' do
    let(:another_contact_1) { FactoryGirl.create :contact, owner: contact.owner.mkey, total_score: 4 }
    let(:another_contact_2) { FactoryGirl.create :contact, owner: contact.owner.mkey, total_score: 6 }
    let(:another_contact_3) { FactoryGirl.create :contact, owner: contact.owner.mkey, total_score: 5 }
    let(:another_contact_4) { FactoryGirl.create :contact, owner: contact.owner.mkey, total_score: 3 }
    subject { instance.another_contacts }

    it do
      expected = [2, 3, 1].map { |num| send "another_contact_#{num}" }
      is_expected.to eq expected
    end
  end
end
