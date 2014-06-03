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
        expect(context_fact_1.id).to be_a(id_class)
      end

      it 'two context_facts have different id' do
        expect(context_fact_1.id).to_not eq context_fact_2.id
      end

      it 'has nil context_subject' do
        expect(context_fact_1.context_subject).to be_nil
      end

      it 'has correct subject' do
        expect(context_fact_1.subject).to eq subject
      end

      it 'has correct predicate' do
        expect(context_fact_1.predicate).to eq 'context:visibility'
      end

      it 'has correct object' do
        expect(context_fact_1.object).to eq 'public'
      end

      it 'raises a ContextError when context_subject is present in options hash' do
        expect { described_class.new(
          context_subject: subject,
          predicate: 'test',
          object: 'test') }.
            to raise_error ContextError
      end
    end
  end
end
