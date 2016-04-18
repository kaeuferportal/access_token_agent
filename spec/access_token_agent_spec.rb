require 'spec_helper'
require 'shared_examples_for_access_token_agent'
module AccessTokenAgent
  describe Connector do
    let(:options) do
      { base_uri: 'http://localhost:8012',
        client_id: 'test_app',
        client_secret: '303b8f4ee401c7a0c756bd3acc549a16ba1ee9b194339c2' \
                       'e2a858574dff3a949' }
    end
    let(:agent) { Connector.new(options) }

    describe '.authenticate' do
      subject { agent.authenticate }

      context 'when an access_token is known for the credentials' do
        let(:known_token) do
          Token.new('expires_in' => 7200, 'token_type' => 'bearer', value: 'xy')
        end

        before { agent.instance_variable_set(:@known_token, known_token) }

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

          context 'and the credentials are valid' do
            it 'does not return the known token value' do
              expect(subject).not_to eq known_token.value
            end

            it 'returns a new token value' do
              expect(subject).to eq 'fa9724f775c8949bb2d680c7cf11f4d40b92879' \
                                    'f16987c0929a78e7a3ce893f4'
            end

            it 'calls auth project' do
              expect(Net::HTTP).to receive(:start).and_call_original
              subject
            end
          end

          it_behaves_like 'with invalid credentials'
        end
      end

      context 'when no access_token is known for the credentials', :vcr do
        context 'and the credentials are valid' do
          it 'returns a new token value' do
            expect(subject).to eq 'b9143de417609e7302bd84fa13034c7557c1eb69a' \
                                  '7aad7362b033c3b4002a858'
          end

          it 'calls auth project' do
            expect(Net::HTTP).to receive(:start).and_call_original
            subject
          end
        end

        it_behaves_like 'with invalid credentials'
      end
    end

    describe '.from_auth', :vcr do
      subject { agent.from_auth }

      context 'when credentials are valid' do
        it 'returns a Hash containing the access_token' do
          expect(subject['access_token']).to eq(
            'eeb81b0efe8d0792e8e41cd9eab6df75d68f48bbd7b600f332d9bd154981ec51'
          )
        end

        it 'returns a Hash containing expires_in' do
          expect(subject['expires_in']).to eq 7200
        end
      end

      it_behaves_like 'with invalid credentials'

      context 'when request is not successful' do
        it 'throws an Error' do
          expect { subject }.to raise_error Error
        end
      end
    end
  end
end
