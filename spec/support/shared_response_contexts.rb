shared_context 'response status' do
  it 'has a 200 status code' do
    expect(response).to have_http_status 200
  end
end
