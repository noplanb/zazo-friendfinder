require 'rails_helper'

RSpec.describe Contact::FindOwnersByContactMatching do
  let(:instance) { described_class.new contact_data }

  describe '#do' do
    subject { instance.do }
    let!(:contact_1) { create :contact, vectors: [create(:vector_mobile, value: '+380930127802')] }
    let!(:contact_2) { create :contact, vectors: [create(:vector_mobile, value: '+380951035160')] }
    let!(:contact_3) { create :contact, vectors: [create(:vector_mobile, value: '+380508891332')] }
    let!(:contact_4) { create :contact, vectors: [create(:vector_mobile, value: '+380951035160')] }
    let(:contact_data) do
      { id: 1,
        mkey: 'xxxxxxxxxxxx',
        mobile_number: contact_mobile,
        first_name: 'Sergei',
        last_name: 'Mavrodi',
        emails: nil,
        status: 'invited' }.stringify_keys
    end

    context 'case 1: by mobile' do
      let(:contact_mobile) { '+380951035160' }
      it { is_expected.to include contact_2, contact_4 }
    end

    context 'case 2: not match' do
      let(:contact_mobile) { '+380937454329' }
      it { is_expected.to eq [] }
    end
  end
end
