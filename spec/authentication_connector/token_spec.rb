require 'spec_helper'

module AuthenticationConnector
  describe Token do
    subject { Token.new(auth_response) }
    let(:auth_response) { { 'token_type' => 'bearer', 'expires_in' => 3600 } }

    describe '.valid?' do
      context 'when token has not expired' do
        it { is_expected.to be_valid }
      end

      context 'when Token has expired' do
        let(:auth_response) { { 'token_type' => 'bearer', 'expires_in' => 0 } }
        it { is_expected.not_to be_valid }
      end
    end

    describe '#initialize' do
      it 'calculates expires_at' do
        expected_expiration = Time.now + auth_response['expires_in']
        expect(subject.expires_at).to be_within(1).of(expected_expiration)
      end

      context 'when token_type is not supported' do
        let(:auth_response) { { 'token_type' => 'mac', 'expires_in' => 3600 } }

        it 'raises an InvalidTokenTypeError' do
          expect { subject }.to raise_error InvalidTokenTypeError
        end
      end
    end
  end
end
