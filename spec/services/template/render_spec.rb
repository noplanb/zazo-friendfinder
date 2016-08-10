require 'rails_helper'

RSpec.describe Template::Render do
  let(:template) { Template.new(notification) }
  let(:instance) { described_class.new(template) }

  describe '#content' do
    subject { instance.content.class }

    context 'when mobile notification' do
      let(:notification) { build(:notification_mobile) }
      it { expect { subject }.to_not raise_exception }
    end

    context 'when email notification' do
      let(:notification) { build(:notification_email) }
      it { expect { subject }.to_not raise_exception }
    end
  end
end
