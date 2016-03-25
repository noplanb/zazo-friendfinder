require 'rails_helper'

RSpec.describe Notification::Create do
  let(:instance) { described_class.new(category, contact) }

  describe '#do' do
    let(:category) { 'user_joined' }
    let(:contact) { FactoryGirl.create(:contact) }
    let(:contact_name) { "#{contact.first_name} #{contact.last_name}" }

    subject do
      instance.do.map { |n| { kind: n.kind, category: n.category } }
    end

    it do
      expected = [
        { kind: 'email',  category: 'user_joined' },
        { kind: 'mobile', category: 'user_joined' }
      ]
      is_expected.to eq expected
    end
    it { expect(subject.size).to eq 2 }
  end
end
