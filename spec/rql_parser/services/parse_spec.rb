require 'spec_helper'

RSpec.describe RqlParser::Services::Parse do
  describe '#args' do
    context 'when two values are given' do
      let(:rql) { 'eq(a,b)' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'eq',
          args: [{ arg: 'a' },
                 { arg: 'b' }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end

    context 'when many values are given' do
      let(:rql) { 'eq(a,b,c,d)' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'eq',
          args: [{ arg: 'a' },
                 { arg: 'b' },
                 { arg: 'c' },
                 { arg: 'd' }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end

    context 'when array of values is given' do
      let(:rql) { 'in((b,c))' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'in',
          args: [{ arg_array: [{ arg: 'b' }, { arg: 'c' }] }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end

    context 'when values and array of values are given' do
      let(:rql) { 'in(a,(b,c),d)' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'in',
          args: [{ arg: 'a' },
                 { arg_array: [{ arg: 'b' }, { arg: 'c' }] },
                 { arg: 'd' }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end

    context 'when nested array of values is given' do
      let(:rql) { 'in(((b,c),d))' }
      let(:function) { described_class.run(rql: rql).errors[:rql] }
      let(:result) { ['is invalid'] }

      it 'returns false' do
        expect(function).to eq(result)
      end
    end

    context 'when *and* expressions are given' do
      let(:rql) { 'or(eq(a,b)&eq(c,d),eq(e,f))' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'or',
          args: [{ type: :function,
                   identifier: 'and',
                   args: [{ type: :function,
                            identifier: 'eq',
                            args: [{ arg: 'a' }, { arg: 'b' }] },
                          { type: :function,
                            identifier: 'eq',
                            args: [{ arg: 'c' }, { arg: 'd' }] }] },
                 { type: :function,
                   identifier: 'eq',
                   args: [{ arg: 'e' }, { arg: 'f' }] }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end

    context 'when nested *and* expressions are given' do
      let(:rql) { 'or((eq(a,b)|eq(c,d))&eq(g,h),eq(e,f))' }
      let(:function) { described_class.run!(rql: rql) }
      let(:result) do
        { type: :function,
          identifier: 'or',
          args: [{ type: :function,
                   identifier: 'and',
                   args: [{ type: :group,
                            args: { type: :function,
                                    identifier: 'or',
                                    args: [{ args: [{ arg: 'a' }, { arg: 'b' }],
                                             identifier: 'eq',
                                             type: :function },
                                           { args: [{ arg: 'c' }, { arg: 'd' }],
                                             identifier: 'eq',
                                             type: :function }] } },
                          { type: :function,
                            identifier: 'eq',
                            args: [{ arg: 'g' }, { arg: 'h' }] }] },
                 { type: :function,
                   identifier: 'eq',
                   args: [{ arg: 'e' }, { arg: 'f' }] }] }
      end

      it 'returns valid args' do
        expect(function).to eq(result)
      end
    end
  end

  describe '#function' do
  end
end
