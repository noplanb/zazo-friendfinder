require 'rails_helper'

RSpec.describe Contact::AddContacts do
  let(:current_user) { FactoryGirl.build :user }
  let(:instance) { described_class.new current_user, params }

  let (:correct_params) do
    vectors = [
      { 'name'  => 'email',
        'value' => 'elfishawy.sani@gmail.com' },
      { 'name'  => 'mobile',
        'value' => '+16502453537',
        'additions' => { 'sms_messages_sent' => 15 } }
    ]
    [{ 'display_name' => 'Sani Elfishawy',
       'vectors'      => vectors,
       'additions'    => { 'marked_as_favorite' => true } }]
  end

  describe '#do' do
    let(:contacts) { Contact.by_owner current_user.mkey }

    context 'with correct params' do
      let!(:subject) { instance.do }
      let(:params)  { correct_params }
      let(:contact) { contacts.first }

      it { is_expected.to be true }
      it { expect(contacts.count).to eq 1 }
      it { expect(contact.display_name).to eq 'Sani Elfishawy' }
      it { expect(contact.vectors.count).to eq 2 }
      it { expect(contact.vectors.pluck(:name)).to include *%w(mobile email) }
    end

    context 'with already persisted contacts' do
      let(:subject) { instance.do }
      let(:params) { correct_params }

      before do
        FactoryGirl.create :contact, owner: current_user.mkey
        instance.do
      end

      it { is_expected.to be false }
      it do
        expect = { contacts: ['contacts by this user already persisted'] }
        expect(instance.errors).to eq expect
      end
    end

    context 'with incorrect vectors params' do
      let!(:subject) { instance.do }
      let(:params) do
        vectors = [
          { 'name'  => 'email',
            'value' => 'asdasd@asdasd',
            'additions' => { 'sms_messages_sent' => 15 } },
          { 'name'  => 'mobile',
            'value' => 'xxxxxxxxx',
            'additions' => { 'email_messages_sent' => 15 } }
        ]
        [{ 'display_name' => 'Sani Elfishawy',
           'vectors'      => vectors }]
      end

      it { is_expected.to be false }
      it { expect(contacts.count).to eq 1 }
      it do
        expect = {
          vectors: [
            { additions: ['\'sms_messages_sent\' is not allowed condition for \'email\' vector'], value: ['\'asdasd@asdasd\' has incorrect format for \'email\' vector'] },
            { additions: ['\'email_messages_sent\' is not allowed condition for \'mobile\' vector'], value: ['\'xxxxxxxxx\' has incorrect format for \'mobile\' vector'] }
          ]
        }
        expect(instance.errors).to eq expect
      end
    end

    context 'with incorrect contact params' do
      let!(:subject) { instance.do }
      let(:params) do
        [{ 'display_name' => 'Sani Elfishawy',
           'additions'    => { 'email_messages_sent' => 15 } }]
      end

      it { is_expected.to be false }
      it { expect(contacts.count).to eq 0 }
      it do
        expect = {
          contacts: [
            { additions: ['\'email_messages_sent\' is not allowed addition'] }
          ]
        }
        expect(instance.errors).to eq expect
      end
    end
  end
end
