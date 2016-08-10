require 'rails_helper'

RSpec.describe Owner::Extensions::Subscription, type: :model do
  let(:mkey) { 'xxxxxxxxxxxx' }
  let(:instance) { Owner.new(mkey) }

  describe '#unsubscribe' do
    subject { instance.unsubscribe }

    shared_context 'unsubscribed shared context' do
      it { expect(instance.unsubscribed?).to be(true) }
      it { expect(Owner::Additions.count).to eq(1) }
      it { expect(Owner::Additions.first.unsubscribed).to eq(true) }
    end

    context 'when already unsubscribed' do
      before do
        create(:owner_additions, mkey: mkey, unsubscribed: true)
        subject
      end

      it_behaves_like 'unsubscribed shared context'
    end

    context 'when subscribed by additions' do
      before do
        create(:owner_additions, mkey: mkey, unsubscribed: false)
        subject
      end

      it_behaves_like 'unsubscribed shared context'
    end

    context 'when subscribed without additions' do
      before { subject }

      it_behaves_like 'unsubscribed shared context'
    end
  end

  describe '#subscribe' do
    subject { instance.subscribe }

    context 'when unsubscribed' do
      before do
        create(:owner_additions, mkey: mkey, unsubscribed: true)
        subject
      end

      it { expect(instance.subscribed?).to be(true) }
      it { expect(Owner::Additions.count).to eq(1) }
      it { expect(Owner::Additions.first.unsubscribed).to eq(false) }
    end

    context 'when already subscribed by additions' do
      before do
        create(:owner_additions, mkey: mkey, unsubscribed: false)
        subject
      end

      it { expect(instance.subscribed?).to be(true) }
      it { expect(Owner::Additions.count).to eq(1) }
      it { expect(Owner::Additions.first.unsubscribed).to eq(false) }
    end

    context 'when already subscribed without additions' do
      before { subject }

      it { expect(instance.subscribed?).to be(true) }
      it { expect(Owner::Additions.count).to eq(0) }
    end
  end
end
