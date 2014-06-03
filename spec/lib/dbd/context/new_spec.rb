require 'spec_helper'

module Dbd
  describe Context do

    let(:context) { described_class.new }
    let(:context_subject) { context.subject }

    describe '.new' do
      describe 'without a subject argument' do
        it 'has created a new subject' do
          expect(context.subject).to be_a(described_class.new_subject.class)
        end
      end

      describe 'with a subject argument' do
        it 'has stored the resource_subject' do
          expect(described_class.new(subject: context_subject).subject).
            to eq context_subject
        end
      end

      describe 'with a context_subject argument' do
        it 'raises an ContextError' do
          expect{ described_class.new(context_subject: context_subject) }.
            to raise_error(ArgumentError)
        end
      end
    end

    describe 'context_subject' do
      it 'raises NoMethodError when called' do
        expect{ context.context_subject }.to raise_error(NoMethodError)
      end
    end
  end
end
