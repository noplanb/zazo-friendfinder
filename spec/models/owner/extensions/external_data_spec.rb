require 'rails_helper'

RSpec.describe Owner::Extensions::ExternalData, type: :model do
  let(:owner_mkey) { 'GBAHb0482YxlJ0kYwbIS' }
  let(:instance) { Owner.new(owner_mkey) }

  describe 'attributes' do
    before { instance.fetch_data }

    context 'for existing user',
      vcr: { cassette: 'attributes_for_existing_user' } do
      it do
        expected = [
          '0DAQEVtmNKQiW6aoQrvo', 'e0kvxfgua1EQJvUOzVC1',
          'yLK6i5VpMW9ZZy5BnXZZ', '7qdanSEmctZ2jPnYA0a1',
          'gpIES8adSGtrB5O5933c', 'LVXE6gyoxb6eHNvPd96f',
          'HFGLjOv9wSPjVAmacRCR']
        expect(instance.friends).to match_array(expected)
      end
    end

    context 'for nonexistent user',
      vcr: { cassette: 'attributes_for_nonexistent_user' } do
      let(:owner_mkey) { 'xxxxxxxxxxxx' }

      it { expect(instance.friends).to eq([]) }
    end
  end
end
