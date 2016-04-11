require 'spec_helper'

module AccessTokenAgent
  describe AccessTokenAgent do
    let(:credentials) do
      Credentials.new('test_app',
                      'e89653dea946cb2618575cc97e7e165c3d4ad20524d43f4ec461' \
                      '157a94675f95')
    end

    describe '.authenticate' do
      subject { described_class.authenticate(credentials) }
      let(:credentials) do
        Credentials.new('test_app',
                        'e89653dea946cb2618575cc97e7e165c3d4ad20524d43f4ec461' \
                        '157a94675f95')
      end

      context 'when an access_token is known for the credentials' do
        let(:known_token) do
          Token.new('expires_in' => 7200, 'token_type' => 'bearer')
        end
        before { described_class.add(credentials, known_token) }

        context 'and it is valid' do
          before { allow(known_token).to receive(:valid?).and_return(true) }

          it 'returns the known access_token' do
            expect(subject).to eq known_token
          end

          it 'does not call auth project' do
            expect(Net::HTTP).not_to receive(:start)
            subject
          end
        end

        context 'and it is invalid', :vcr do
          before { allow(known_token).to receive(:valid?).and_return(false) }

          it 'does not return the known token' do
            expect(subject).not_to eq known_token
          end

          it 'returns a new token' do
            expect(subject).to be_kind_of Token
          end

          it 'calls auth project' do
            expect(Net::HTTP).to receive(:start).and_call_original
            subject
          end
        end
      end

      context 'when no access_token is known for the credentials', :vcr do
        it 'returns a token' do
          expect(subject).to be_kind_of Token
        end

        it 'calls auth project' do
          expect(Net::HTTP).to receive(:start).and_call_original
          subject
        end
      end
    end

    describe '.from_auth', :vcr do
      subject { described_class.from_auth(credentials) }

      context 'when credentials are valid' do
        it 'returns a Hash containing the access_token' do
          expect(subject['access_token']).to eq(
            'f265cf6640f2cbf3e52def5ce0ef12a54e8ff9eba475bcf6f79a0fa3b70d748d'
          )
        end

        it 'returns a Hash containing expires_in' do
          expect(subject['expires_in']).to eq 7200
        end
      end

      context 'when credentials are invalid' do
        let(:credentials) { Credentials.new('test_app', '157a94675f95') }

        it 'throws an UnauthorizedError' do
          expect { subject }.to raise_error UnauthorizedError
        end
      end

      context 'when request is not successful' do
        it 'throws an Error' do
          expect { subject }.to raise_error Error
        end
      end
    end
  end
end
