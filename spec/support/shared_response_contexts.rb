shared_context 'response redirect' do
  it { expect(response).to redirect_to(web_client_path) }
end
