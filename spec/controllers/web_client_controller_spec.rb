require 'rails_helper'

RSpec.describe WebClientController, type: :controller, authenticate_with_http_basic: true do
  let(:contact) { FactoryGirl.create :contact }
  let(:notification) { FactoryGirl.create :notification, contact: contact }
  let(:nkey) { notification.nkey }

  render_views

  describe 'GET #show' do
    context 'with correct nkey' do
      before { get :show, id: nkey }

      it_behaves_like 'response status'
      it { expect(response).to render_template(:show) }
    end

    context 'with incorrect nkey' do
      before { get :show, id: 'xxxxxxxxxxxx' }

      it_behaves_like 'response status'
      it { expect(response).to render_template(:default) }
    end
  end

  describe 'GET #add' do
    before { get :add, id: nkey }

    it_behaves_like 'response status'
    it { expect(response).to render_template(:add) }
    it { expect(notification.reload.status).to eq 'added' }
  end

  describe 'GET #ignore' do
    before { get :ignore, id: nkey }

    it_behaves_like 'response status'
    it { expect(response).to render_template(:ignore) }
    it { expect(notification.reload.status).to eq 'ignored' }
  end

  describe 'GET #unsubscribe' do
    before { get :unsubscribe, id: nkey }

    it_behaves_like 'response status'
    it { expect(response).to render_template(:unsubscribe) }
    it { expect(notification.reload.status).to eq 'unsubscribed' }
  end

  describe 'GET #subscribe' do
    let!(:notification) { FactoryGirl.create :notification, contact: contact, status: 'unsubscribed' }
    before { get :subscribe, id: notification.nkey }

    it { expect(notification.reload.status).to eq nil }
    it { expect(response).to redirect_to(web_client_path) }
  end
end
