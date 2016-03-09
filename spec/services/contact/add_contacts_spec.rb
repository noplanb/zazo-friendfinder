require 'rails_helper'

RSpec.describe Contact::AddContacts do
  let(:current_user) { FactoryGirl.build :user }
  let(:instance) { described_class.new(current_user.mkey, params) }

  let(:correct_params) do
    [
      {
        'display_name' => 'Sani Elfishawy',
        'vectors' => [
          { 'name' => 'email',  'value' => 'elfishawy.sani@gmail.com' },
          { 'name' => 'mobile', 'value' => '+16502453537', 'additions' => { 'sms_messages_sent' => 15 } }
        ],
        'additions' => {
          'marked_as_favorite' => true,
          'rejected_by_owner' => true }
      }
    ]
  end

  describe '#do' do
    let(:contacts) { Contact.by_owner(current_user.mkey) }

    context 'with correct params' do
      let!(:subject) { instance.do }
      let(:params)  { correct_params }
      let(:contact) { contacts.first }

      it { is_expected.to be true }
      it { expect(contacts.count).to eq 1 }
      it { expect(contact.display_name).to eq 'Sani Elfishawy' }
      it { expect(contact.vectors.count).to eq 2 }
      it { expect(contact.vectors.pluck(:name)).to match_array %w(mobile email) }
    end

    context 'with correct params that need to be merged' do
      let(:contact) { contacts.first }
      let(:params) do
        [
          {
            'display_name' => 'Sani Elfishawy',
            'vectors' => [
              { 'name' => 'mobile', 'value' => '+16502453537' },
              { 'name' => 'gplus',  'value' => 'elfishawy.sani@gmail.com' }
            ]
          }
        ]
      end
      let(:subject) { instance.do }
      let(:all_contact_vectors) do
        contact.reload.vectors.map { |v| [v.name, v.value] }
      end

      before do
        described_class.new(current_user.mkey, correct_params).do
        instance.do
      end

      it { is_expected.to be true }
      it { expect(contact.reload.vectors.count).to eq 3 }
      it do
        expected = [
          %w(mobile +16502453537),
          %w(email elfishawy.sani@gmail.com),
          %w(gplus elfishawy.sani@gmail.com)
        ]
        expect(all_contact_vectors).to match_array expected
      end
    end

    context 'with incorrect vectors params' do
      let!(:subject) { instance.do }
      let(:params) do
        [
          {
            'display_name' => 'Sani Elfishawy',
            'vectors'      => [
              { 'name'  => 'email',
                'value' => 'asdasd@asdasd',
                'additions' => { 'sms_messages_sent' => 15 } },
              { 'name'  => 'mobile',
                'value' => 'xxxxxxxxx',
                'additions' => { 'email_messages_sent' => 15 } }
            ]
          }
        ]
      end

      it { is_expected.to be false }
      it { expect(contacts.count).to eq 1 }
      it do
        expected = {
          vectors: [
            { additions: ['\'sms_messages_sent\' is not allowed condition for \'email\' vector'], value: ['\'asdasd@asdasd\' has incorrect format for \'email\' vector'] },
            { additions: ['\'email_messages_sent\' is not allowed condition for \'mobile\' vector'], value: ['\'xxxxxxxxx\' has incorrect format for \'mobile\' vector'] }
          ]
        }
        expect(instance.errors).to eq expected
      end
    end

    context 'with incorrect contact params' do
      let!(:subject) { instance.do }
      let(:params) do
        [
          {
            'display_name' => 'Sani Elfishawy',
            'additions'    => { 'email_messages_sent' => 15 }
          }
        ]
      end

      it { is_expected.to be false }
      it { expect(contacts.count).to eq 0 }
      it do
        expected = {
          contacts: [ { additions: ['\'email_messages_sent\' is not allowed addition'] } ]
        }
        expect(instance.errors).to eq expected
      end
    end
  end
end
