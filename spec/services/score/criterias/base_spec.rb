require 'rails_helper'

RSpec.describe Score::Criterias::Base do
  let(:instance) { described_class.new FactoryGirl.create(:contact) }

  describe '#save' do
    context 'with invalid name' do
      subject { instance.save }

      it { is_expected.to.not be_valid }
      it { expect(subject.name).to eq 'base' }
      it { expect(subject.persisted?).to be_false }
    end
  end
end
