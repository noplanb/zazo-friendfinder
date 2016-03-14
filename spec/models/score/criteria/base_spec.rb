require 'rails_helper'

RSpec.describe Score::Criteria::Base do
  let(:instance) { described_class.new(FactoryGirl.create(:contact)) }

  describe '#save' do
    context 'with invalid name' do
      subject { instance.save }

      it { is_expected.to_not be_valid }
      it { expect(subject.name).to eq 'base' }
      it { expect(subject.persisted?).to be false }
    end
  end
end
