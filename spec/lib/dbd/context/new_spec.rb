require 'spec_helper'

module Dbd
  describe Context do

    let(:context) { described_class.new }
    let(:context_subject) { context.subject }

    describe '.new' do
      describe 'without a subject argument' do
        it 'has created a new subject' do
          context.subject.should be_a(described_class.new_subject.class)
        end
      end

      describe 'with a subject argument' do
        it 'has stored the resource_subject' do
          described_class.new(subject: context_subject).subject.
            should == context_subject
        end
      end

      describe 'with a context_subject argument' do
        it 'raises an ContextError' do
          lambda{ described_class.new(context_subject: context_subject) }.
            should raise_error(ArgumentError)
        end
      end
    end

    describe 'context_subject' do
      it 'raises NoMethodError when called' do
        lambda{ context.context_subject }.should raise_error(NoMethodError)
      end
    end
  end
end
