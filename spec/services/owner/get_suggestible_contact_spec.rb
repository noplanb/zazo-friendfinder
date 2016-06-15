require 'rails_helper'

RSpec.describe Owner::GetSuggestibleContact do
  let(:owner) { Owner.new('FaGUU1xx60N2cOufnV1v') }
  let(:instance) { described_class.new(owner) }

  describe '#call' do
    subject { instance.call }

    context 'common case' do
      let!(:contact_1) { create_contact(owner.mkey, 8, '+380987777777', 'marked_as_friend' => false) } # friend on server
      let!(:contact_2) { create_contact(owner.mkey, 6, '+380951035167', 'marked_as_friend' => true) }
      let!(:contact_3) { create_contact(owner.mkey, 4, '+16507800181',  'marked_as_friend' => false) } # not friend on server
      let!(:contact_4) { create_contact(owner.mkey, 2, '+12345678910',  'marked_as_friend' => false) }

      it do
        contact = subject
        contact_1.reload
        contact_3.reload

        expect(contact_1.zazo_mkey).to eq('YRn7ZUDIZI3WzdKT8WxA')
        expect(contact_1.marked_as_friend?).to eq(true)
        expect(contact_3.id).to eq(contact.id)
        expect(contact_3.reload.zazo_mkey).to eq('yKCS3YZwl1bWbuIFNLE0')
      end
    end

    context 'no contact to suggest case' do
      let!(:contact_1) { create_contact(owner.mkey, 8, '+380987777777', 'marked_as_friend' => false) } # friend on server
      let!(:contact_2) { create_contact(owner.mkey, 6, '+380951035167', 'marked_as_friend' => true) }
      let!(:contact_3) { create_contact(owner.mkey, 4, '+16507800181',  'marked_as_friend' => true) }
      let!(:contact_4) { create_contact(owner.mkey, 2, '+12345678910',  'marked_as_friend' => true) }

      it { is_expected.to be(nil) }
    end
  end
end
