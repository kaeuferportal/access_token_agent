require 'spec_helper'

module AccessTokenAgent
  describe AccessTokenAgent do
    describe '.authenticate' do
      subject { described_class.authenticate }

      context 'when an access_token is known for the credentials' do
        let(:known_token) do
          Token.new('expires_in' => 7200, 'token_type' => 'bearer', value: 'xy')
        end

        before { described_class.add(known_token) }

        context 'and it is valid' do
          before { allow(known_token).to receive(:valid?).and_return(true) }

          it 'returns the known access_token' do
            expect(subject).to eq known_token.value
          end

          it 'does not call auth project' do
            expect(Net::HTTP).not_to receive(:start)
            subject
          end
        end

        context 'and it is invalid', :vcr do
          before { allow(known_token).to receive(:valid?).and_return(false) }

          it 'does not return the known token value' do
            expect(subject).not_to eq known_token.value
          end

          it 'returns a new token value' do
            expect(subject).to eq 'ea142e8925c9dcb7ed130b62ce4c26e171f92096' \
                                  '501cb5251745917efd891f46'
          end

          it 'calls auth project' do
            expect(Net::HTTP).to receive(:start).and_call_original
            subject
          end
        end
      end

      context 'when no access_token is known for the credentials', :vcr do
        it 'returns a new token value' do
          expect(subject).to eq '31e49e8344c1886e8324ddb08ccbade9fc0b090155' \
                                '3dfd9c78c59aa98beab80d'
        end

        it 'calls auth project' do
          expect(Net::HTTP).to receive(:start).and_call_original
          subject
        end
      end
    end

    describe '.from_auth', :vcr do
      subject { described_class.from_auth }

      context 'when credentials are valid' do
        it 'returns a Hash containing the access_token' do
          expect(subject['access_token']).to eq(
            'c5545520092b5aa49233cbccb423020027e23a9a42464efb0611016ef04c7bb8'
          )
        end

        it 'returns a Hash containing expires_in' do
          expect(subject['expires_in']).to eq 7200
        end
      end

      context 'when credentials are invalid' do
        before { described_class.configure('client_secret' => '157a94675f95') }

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
