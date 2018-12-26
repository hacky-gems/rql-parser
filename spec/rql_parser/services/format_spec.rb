require 'spec_helper'

RSpec.describe RqlParser::Services::Format do
  describe 'happy path' do
    let(:function) { described_class.run!(rql: rql) }

    context 'when shorthands are given' do
      let(:rql) { 'a=eq=b,c=ne=d,e=gt=f,g=ge=h,i=lt=j,k=le=l' }
      let(:result) { 'eq(a,b),ne(c,d),gt(e,f),ge(g,h),lt(i,j),le(k,l)' }

      it 'returns valid string' do
        expect(function).to eq(result)
      end
    end

    context 'when shorthands of shorthands are given' do
      let(:rql) { 'a=b,c!=d,e>f,g>=h,i<j,k<=l' }
      let(:result) { 'eq(a,b),ne(c,d),gt(e,f),ge(g,h),lt(i,j),le(k,l)' }

      it 'returns valid string' do
        expect(function).to eq(result)
      end
    end

    context 'when whitespace is given' do
      let(:rql) { 'eq(a , b) , c != d,gt( e,f ),ge(g, h),lt(i,j ),le(k ,l)' }
      let(:result) { 'eq(a,b),ne(c,d),gt(e,f),ge(g,h),lt(i,j),le(k,l)' }

      it 'returns valid string' do
        expect(function).to eq(result)
      end
    end
  end

  describe 'unhappy path' do
    let(:function) { described_class.run(rql: rql).errors[:rql] }

    context 'when query has invalid symbols' do
      let(:rql) { '???' }
      let(:result) { ['has invalid format'] }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when incorrect whitespace is given' do
      let(:rql) { 'eq (a,b),c!=d,g t(e,f),ge(g a,h),lt (i,j),l e (k,l)' }
      let(:result) { ['has invalid whitespace'] }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end

    context 'when incorrect shorthands are given' do
      let(:rql) { 'a==b,c=!=d' }
      let(:result) { ['has invalid shorthands'] }

      it 'raises error' do
        expect(function).to eq(result)
      end
    end
  end
end
