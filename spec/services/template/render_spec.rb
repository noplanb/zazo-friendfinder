require 'rails_helper'

RSpec.describe Template::Render do
  let(:template) { Template.new notification }
  let(:instance) { described_class.new template }

  describe '#content' do
    subject { instance.content.class }

    context 'when mobile notification' do
      let(:notification) { FactoryGirl.build :notification_mobile }
      it { is_expected.to eq ActiveSupport::SafeBuffer }
    end

    context 'when email notification' do
      let(:notification) { FactoryGirl.build :notification_email }
      it { is_expected.to eq ActiveSupport::SafeBuffer }
    end
  end
end
