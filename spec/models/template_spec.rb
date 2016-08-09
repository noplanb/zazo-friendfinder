require 'rails_helper'

RSpec.describe Template, type: :model do
  let(:notification) { create :notification_mobile }
  let(:instance) { described_class.new notification }

  describe '#notification' do
    subject { instance.notification }
    it { is_expected.to eq notification }
  end

  describe '#view_path' do
    subject { instance.view_path }
    it { is_expected.to eq 'templates/_mobile_template' }
  end
end
