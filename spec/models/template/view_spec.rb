require 'rails_helper'

RSpec.describe Template::ViewData, type: :model do
  let(:notification) { FactoryGirl.build :notification }
  let(:instance) { described_class.new notification }

  describe 'attributes' do
    it { expect(instance.contact.name).to eq notification.contact.display_name }
    it { expect(instance.add_link).to eq "#{Figaro.env.friendfinder_base_url}/w/#{notification.nkey}/add" }
    it { expect(instance.ignore_link).to eq "#{Figaro.env.friendfinder_base_url}/w/#{notification.nkey}/ignore" }
    it { expect(instance.unsubscribe_link).to eq "#{Figaro.env.friendfinder_base_url}/w/#{notification.nkey}/unsubscribe" }
  end
end
