require 'rails_helper'

RSpec.describe Contact::AddContacts do
  let(:user) { FactoryGirl.build :user }
  let(:instance) { described_class.new user, params }

  describe '#do' do
    let!(:subject) { instance.do }
    let(:contacts) { Contact.by_owner user.mkey }

    context 'with correct params' do
      let(:params) do
        vectors = [
          { 'name'  => 'email',
            'value' => 'elfishawy.sani@gmail.com',
            'additions' => { 'marked_as_favorite' => true } },
          { 'name'  => 'mobile',
            'value' => '+16502453537',
            'additions' => { 'sms_messages_sent' => 15 } }
        ]
        [{ 'first_name' => 'Sani',
           'last_name'  => 'Elfishawy',
           'vectors'    => vectors }]
      end
      let(:contact)  { contacts.first }

      it { is_expected.to be true }
      it { expect(contacts.count).to eq 1 }
      it { expect(contact.first_name).to eq 'Sani' }
      it { expect(contact.last_name).to eq 'Elfishawy' }
      it { expect(contact.vectors.count).to eq 2 }
      it { expect(contact.vectors.pluck(:name)).to eq %w(mobile email) }
    end

    context 'with incorrect params' do
      let(:params) do
        vectors = [
          { 'name'  => 'email',
            'value' => 'asdasd@asdasd',
            'additions' => { 'sms_messages_sent' => 15 } },
          { 'name'  => 'mobile',
            'value' => 'xxxxxxxxx',
            'additions' => { 'email_messages_sent' => 15 } }
        ]
        [{ 'first_name' => 'Sani',
           'last_name'  => 'Elfishawy',
           'vectors'    => vectors }]
      end

      it { is_expected.to be false }
      it { expect(contacts.count).to eq 0 }
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
  end
end
