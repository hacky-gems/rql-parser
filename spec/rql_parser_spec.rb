require 'spec_helper'

RSpec.describe RqlParser do
  describe '#from_params' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::FromParams).to receive(:run)
        RqlParser.from_params(params: 'params')
      end
    end
  end

  describe '#from_params!' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::FromParams).to receive(:run!)
        RqlParser.from_params!(params: 'params')
      end
    end
  end

  describe '#parse' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::Parse).to receive(:run)
        RqlParser.parse(rql: 'rql')
      end
    end
  end

  describe '#parse!' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::Parse).to receive(:run!)
        RqlParser.parse!(rql: 'rql')
      end
    end
  end
end
