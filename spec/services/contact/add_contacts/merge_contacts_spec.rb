require 'rails_helper'

RSpec.describe Contact::AddContacts::MergeContacts do
  let(:owner) { FactoryGirl.build(:user).mkey }
  let(:instance) { described_class.new owner, contact_data }
  let(:contact_data) do
    { 'display_name' => 'Sani Elfishawy', 'vectors' => vectors }
  end
  let!(:existing_contact) do
    FactoryGirl.create :contact, owner: owner, vectors: [
      FactoryGirl.build(:vector, name: 'mobile', value: '+16502453537'),
      FactoryGirl.build(:vector, name: 'email',  value: 'elfishawy.sani@gmail.com'),
      FactoryGirl.build(:vector, name: 'gplus',  value: 'elfishawy.sani@gmail.com')
    ]
  end

  describe '#do' do
    let(:vectors) do
      [ { 'name' => 'mobile', 'value' => '+16502453537' },
        { 'name' => 'email',  'value' => 'sani.elfishawy@gmail.com' },
        { 'name' => 'gplus',  'value' => 'sani.elfishawy@gmail.com' } ]
    end
    let(:existing_contact_vectors) do
      existing_contact.reload.vectors.map { |v| [v.name, v.value] }
    end
    before do
      instance.do do |contact, vector_data|
        Vector.create contact: contact, name: vector_data['name'], value: vector_data['value']
      end
    end

    it do
      expect = [
        %w(mobile +16502453537),
        %w(email elfishawy.sani@gmail.com), %w(gplus elfishawy.sani@gmail.com),
        %w(email sani.elfishawy@gmail.com), %w(gplus sani.elfishawy@gmail.com)
      ]
      expect(existing_contact_vectors).to include *expect
    end
  end

  describe '#necessary_to?' do
    let(:subject) { instance.necessary_to? }
    before { instance.necessary_to? }

    context 'when contacts match by mobile vector' do
      let(:vectors) do
        [ { 'name' => 'mobile', 'value' => '+16502453537' } ]
      end

      it { is_expected.to be true }
      it { expect(instance.last_coincidence).to eq existing_contact }
    end

    context 'when contacts match by two non-mobile vectors' do
      let(:vectors) do
        [ { 'name' => 'email', 'value' => 'elfishawy.sani@gmail.com' },
          { 'name' => 'gplus', 'value' => 'elfishawy.sani@gmail.com' } ]
      end

      it { is_expected.to be true }
      it { expect(instance.last_coincidence).to eq existing_contact }
    end

    context 'when contacts match by one non-mobile vector' do
      let(:vectors) do
        [ { 'name' => 'email', 'value' => 'elfishawy.sani@gmail.com' } ]
      end

      it { is_expected.to be false }
      it { expect(instance.last_coincidence).to be_nil }
    end

    context 'when contacts not match' do
      let(:vectors) do
        [ { 'name' => 'email', 'value' => 'sani.elfishawy@gmail.com' } ]
      end

      it { is_expected.to be false }
      it { expect(instance.last_coincidence).to be_nil }
    end
  end
end
