require 'spec_helper'

module AuthenticationConnector
  describe Credentials do
    let(:credentials) { Credentials.new('1', 'test123') }

    context 'when comparing two credentials' do
      context 'and client_ids do not match' do
        let(:other_credentials) { Credentials.new('2', 'test123') }

        it 'they are not equal' do
          expect(credentials == other_credentials).to be false
          expect(credentials.eql? other_credentials).to be false
        end
      end

      context 'and client_secrets do not match' do
        let(:other_credentials) { Credentials.new('1', 'abc') }

        it 'they are not equal' do
          expect(credentials == other_credentials).to be false
          expect(credentials.eql? other_credentials).to be false
        end
      end

      context 'and client_ids and client_secrets are equal' do
        let(:other_credentials) { credentials.clone }

        it 'they are equal' do
          expect(credentials == other_credentials).to be true
          expect(credentials.eql? other_credentials).to be true
        end

        it 'they have the same hash' do
          expect(credentials.hash).to eql other_credentials.hash
        end
      end
    end
  end
end
