require 'spec_helper'

module Dbd
  describe ContextFact do

    let(:subject) { described_class.factory.new_subject }
    let(:id_class) { described_class.factory.new_id.class }

    let(:context_fact_1) do
      TestFactories::ContextFact.visibility(subject)
    end

    let(:context_fact_2) do
      TestFactories::ContextFact.created_by(subject)
    end

    describe '#new' do
      it 'has a unique id (new_id.class)' do
        context_fact_1.id.should be_a(id_class)
      end

      it 'two context_facts have different id' do
        context_fact_1.id.should_not == context_fact_2.id
      end

      it 'has nil context_subject' do
        context_fact_1.context_subject.should be_nil
      end

      it 'has correct subject' do
        context_fact_1.subject.should == subject
      end

      it 'has correct predicate' do
        context_fact_1.predicate.should == 'context:visibility'
      end

      it 'has correct object' do
        context_fact_1.object.should == 'public'
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
