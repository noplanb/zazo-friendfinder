require 'rails_helper'

RSpec.describe Owner::Extensions::ExternalData, type: :model do
  use_vcr_cassette 'owner/fetch_data/attributes_by_GBAHb0482YxlJ0kYwbIS', api_base_urls
  use_vcr_cassette 'owner/fetch_data/attributes_by_nonexistent_user', api_base_urls

  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:instance) { Owner.new(owner_mkey) }

  describe 'attributes' do
    before { instance.fetch_data }

    context 'for existing user' do
      it do
        expected = %w(0DAQEVtmNKQiW6aoQrvo e0kvxfgua1EQJvUOzVC1 yLK6i5VpMW9ZZy5BnXZZ 7qdanSEmctZ2jPnYA0a1 gpIES8adSGtrB5O5933c LVXE6gyoxb6eHNvPd96f)
        expect(instance.friends).to match_array expected
      end
    end

    context 'for nonexistent user' do
      let(:owner_mkey) { 'xxxxxxxxxxxx' }

      it { expect(instance.friends).to eq [] }
    end
  end
end
