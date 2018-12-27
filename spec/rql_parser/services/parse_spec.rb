require 'spec_helper'

RSpec.describe RqlParser::Services::Parse do
  describe 'happy path' do
    let(:function) { described_class.run!(rql: rql) }

    context 'when simple *and* is given' do
      let(:rql) { 'a(b,c)&e(f,g)' }
      let(:result) do
        { type: :function,
          identifier: :and,
          args: [{ type: :function,
                   identifier: :a,
                   args: [{ arg: 'b' },
                          { arg: 'c' }] },
                 { type: :function,
                   identifier: :e,
                   args: [{ arg: 'f' },
                          { arg: 'g' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when simple *or* is given' do
      let(:rql) { 'a(b,c);e(f,g)' }
      let(:result) do
        { type: :function,
          identifier: :or,
          args: [{ type: :function,
                   identifier: :a,
                   args: [{ arg: 'b' },
                          { arg: 'c' }] },
                 { type: :function,
                   identifier: :e,
                   args: [{ arg: 'f' },
                          { arg: 'g' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when complex expression is given' do
      let(:rql) { 'eq(smock,80)&age=eq=30&(time=ge=22|eq(time,40))&(weight<30|weight>=50)&(hello=123)' }
      let(:result) do
        { type: :function,
          identifier: :and,
          args: [{ type: :function,
                   identifier: :eq,
                   args: [{ arg: 'smock' },
                          { arg: '80' }] },
                 { type: :function,
                   identifier: :eq,
                   args: [{ arg: 'age' },
                          { arg: '30' }] },
                 { type: :function,
                   identifier: :or,
                   args: [{ type: :function,
                            identifier: :ge,
                            args: [{ arg: 'time' },
                                   { arg: '22' }] },
                          { type: :function,
                            identifier: :eq,
                            args: [{ arg: 'time' },
                                   { arg: '40' }] }] },
                 { type: :function,
                   identifier: :or,
                   args: [{ type: :function,
                            identifier: :lt,
                            args: [{ arg: 'weight' },
                                   { arg: '30' }] },
                          { type: :function,
                            identifier: :ge,
                            args: [{ arg: 'weight' },
                                   { arg: '50' }] }] },
                 { type: :function,
                   identifier: :eq,
                   args: [{ arg: 'hello' },
                          { arg: '123' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when function is given' do
      let(:rql) { 'a(b,c)' }
      let(:result) do
        { type: :function,
          identifier: :a,
          args: [{ arg: 'b' },
                 { arg: 'c' }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when multi args function is given' do
      let(:rql) { 'a(b,c,d,e)' }
      let(:result) do
        { type: :function,
          identifier: :a,
          args: [{ arg: 'b' },
                 { arg: 'c' },
                 { arg: 'd' },
                 { arg: 'e' }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when function with args array is given' do
      let(:rql) { 'a((b,c))' }
      let(:result) do
        { type: :function,
          identifier: :a,
          args: [{ arg_array: [{ arg: 'b' },
                               { arg: 'c' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when function with different types of args is given' do
      let(:rql) { 'a(b,(c,d),e)' }
      let(:result) do
        { type: :function,
          identifier: :a,
          args: [{ arg: 'b' },
                 { arg_array: [{ arg: 'c' },
                               { arg: 'd' }] },
                 { arg: 'e' }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when function with complex params is given' do
      let(:rql) { 'or(eq(a,b)&eq(c,d),eq(e,f))' }
      let(:result) do
        { type: :function,
          identifier: :or,
          args: [{ type: :function,
                   identifier: :and,
                   args: [{ type: :function,
                            identifier: :eq,
                            args: [{ arg: 'a' },
                                   { arg: 'b' }] },
                          { type: :function,
                            identifier: :eq,
                            args: [{ arg: 'c' },
                                   { arg: 'd' }] }] },
                 { type: :function,
                   identifier: :eq,
                   args: [{ arg: 'e' },
                          { arg: 'f' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end

    context 'when function with complex nested params is given' do
      let(:rql) { 'or((eq(a,b)|eq(c,d))&eq(g,h),eq(e,f))' }
      let(:result) do
        { type: :function,
          identifier: :or,
          args: [{ type: :function,
                   identifier: :and,
                   args: [{ type: :function,
                            identifier: :or,
                            args: [{ type: :function,
                                     identifier: :eq,
                                     args: [{ arg: 'a' },
                                            { arg: 'b' }] },
                                   { type: :function,
                                     identifier: :eq,
                                     args: [{ arg: 'c' },
                                            { arg: 'd' }] }] },
                          { type: :function,
                            identifier: :eq,
                            args: [{ arg: 'g' },
                                   { arg: 'h' }] }] },
                 { type: :function,
                   identifier: :eq,
                   args: [{ arg: 'e' },
                          { arg: 'f' }] }] }
      end

      it 'returns valid binary tree' do
        expect(function).to eq(result)
      end
    end
  end

  describe 'unhappy path' do
    let(:function) { described_class.run(rql: rql).errors[:rql] }
    let(:result) { ['is invalid'] }

    context 'when too many closing braces are present' do
      let(:rql) { 'a(b,c))' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when there are not enough closing braces' do
      let(:rql) { 'a(b,c' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when group without meaning is given' do
      let(:rql) { '(a,b)' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when variable without context is given' do
      let(:rql) { 'eq(a,b)&a' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when too deeply nested params are given' do
      let(:rql) { 'a(((b,c),d))' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when empty braces are given' do
      let(:rql) { '()' }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end
  end
end
