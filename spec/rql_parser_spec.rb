require 'spec_helper'

RSpec.describe RqlParser do
  let(:input) { 'input' }

  describe '#from_params' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::FromParams).to receive(:run).with(params: input)
        RqlParser.from_params(input)
      end
    end
  end

  describe '#from_params!' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::FromParams).to receive(:run!).with(params: input)
        RqlParser.from_params!(input)
      end
    end
  end

  describe '#parse' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::Parse).to receive(:run).with(rql: input)
        RqlParser.parse(input)
      end
    end
  end

  describe '#parse!' do
    context 'when method is called' do
      it 'calls a service' do
        expect(RqlParser::Services::Parse).to receive(:run!).with(rql: input)
        RqlParser.parse!(input)
      end
    end
  end
end
