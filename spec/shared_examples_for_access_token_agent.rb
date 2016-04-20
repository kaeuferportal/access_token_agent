RSpec.shared_examples 'with invalid credentials' do
  let(:options) do
    { host: 'http://localhost:8012',
      client_id: 'test_app',
      client_secret: '157a94675f95' }
  end

  it 'throws an UnauthorizedError' do
    expect { subject }.to raise_error AccessTokenAgent::UnauthorizedError
  end
end
