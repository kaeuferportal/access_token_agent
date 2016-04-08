require 'spec_helper'

describe AuthenticationConnector do
  describe '.authenticate' do
    subject { described_class.authenticate(credentials) }
    let(:credentials) { Credentials.new('my_app', 'MySecretPassword') }

    context 'when an access_token is known for the credentials' do
      let(:known_token) { Token.new('bbbb') }
      before { described_class.add(credentials, known_token) }

      context 'and it is valid' do
        before { allow(known_token).to receive(:valid?).and_return(true) }

        it 'returns the known access_token' do
          expect(subject).to eq known_token
        end
      end

      context 'and it is invalid' do
        before { allow(known_token).to receive(:valid?).and_return(false) }

        it 'does not return the known token' do
          expect(subject).not_to eq known_token
        end

        it 'returns a new token' do
          expect(subject).to be_kind_of Token
        end

        it 'retrieves a new token' do
          expect(described_class).to receive(:token_from_auth)
          subject
        end
      end
    end

    context 'when no access_token is known for the credentials' do
      it 'returns a new token' do
        expect(subject).to be_kind_of Token
      end

      it 'retrieves a new token' do
        expect(described_class).to receive(:token_from_auth)
        subject
      end
    end
  end

  describe '.token_from_auth' do
    context 'when credentials are valid' do
      it 'returns an access_token' do
      end
    end

    context 'when credentials are invalid' do
      it 'throws an error' do
      end
    end
  end
end
