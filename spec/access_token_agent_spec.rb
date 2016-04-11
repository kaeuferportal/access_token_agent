require 'spec_helper'

module AccessTokenAgent
  describe AccessTokenAgent do
    describe '.authenticate' do
      subject { described_class.authenticate(credentials) }
      let(:credentials) do
        Credentials.new('test_app',
                        'e89653dea946cb2618575cc97e7e165c3d4ad20524d43f4ec46115' \
                        '7a94675f95')
      end

      context 'when an access_token is known for the credentials' do
        let(:known_token) do
          Token.new('expires_in' => 7200, 'token_type' => 'bearer'  )
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

        context 'and it is invalid' do
          use_vcr_cassette

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

      context 'when no access_token is known for the credentials' do
        use_vcr_cassette

        it 'returns a token' do
          expect(subject).to be_kind_of Token
        end

        it 'calls auth project' do
          expect(Net::HTTP).to receive(:start).and_call_original
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
end
