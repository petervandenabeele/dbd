require 'spec_helper'

module Dbd
  describe Context do

    let(:subject) { described_class.factory.new_subject }
    let(:id_class) { described_class.factory.new_id.class }

    let(:context_1) do
      TestFactories::Context.visibility(subject)
    end

    let(:context_2) do
      TestFactories::Context.created_by(subject)
    end

    describe '#new' do
      it 'has a unique id (new_id.class)' do
        context_1.id.should be_a(id_class)
      end

      it 'two contexts have different id' do
        context_1.id.should_not == context_2.id
      end

      it 'has nil context_subject' do
        context_1.context_subject.should be_nil
      end

      it 'has correct subject' do
        context_1.subject.should == subject
      end

      it 'has correct predicate' do
        context_1.predicate.should == 'context:visibility'
      end

      it 'has correct object' do
        context_1.object.should == 'public'
      end

      it 'raises a ContextError when context_subject is present in options hash' do
        lambda { described_class.new(
          context_subject: subject,
          predicate: 'test',
          object: 'test') } .
            should raise_error ContextError
      end
    end
  end
end
