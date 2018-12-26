require 'spec_helper'

RSpec.describe RqlParser::Services::FromParams do
  describe '#run' do
    context 'when params are given' do
      let(:params) { { 'eq(a,b)' => nil, c: 'd' } }
      let(:function) { described_class.run!(params: params) }
      let(:result) do
        { type: :function,
          identifier: 'and',
          args: [{ type: :function,
                   identifier: 'eq',
                   args: [{ arg: 'a' },
                          { arg: 'b' }] },
                 { type: :function,
                   identifier: 'eq',
                   args: [{ arg: 'c' },
                          { arg: 'd' }] }] }
      end

      it 'transforms params to RQL' do
        expect(function).to eq(result)
      end
    end
  end
end
