require 'spec_helper'

module Dbd
  describe ContextFact do

    let(:subject) { described_class.factory.new_subject }

    let(:context_fact_1) do
      TestFactories::ContextFact.visibility(subject)
    end

    let(:context_fact_created) do
      TestFactories::ContextFact.created(subject)
    end

    describe 'short' do
      it 'for a context_fact fact shows [ cont ], subj, predicate, object' do
        expect(context_fact_1.short).to match(/^\[ cont \] : [0-9a-f]{8} : context:visibility       : public$/)
      end

      it 'for a context_fact fact with non string object also works' do
        expect(context_fact_created.short).to match(/^\[ cont \] : [0-9a-f]{8} : dcterms:created          : \d{4}/)
      end
    end

    describe 'errors' do
      it 'the factory has no errors' do
        expect(context_fact_1.errors).to be_empty
      end

      describe 'with a context_subject' do

        before(:each) do
          allow(context_fact_1).to receive(:context_subject) { subject }
        end

        it 'errors returns an array with 1 error message' do
          expect(context_fact_1.errors.single).to match(/ContextFact subject should not be present in ContextFact/)
        end
      end

      describe 'without subject' do

        before(:each) do
          allow(context_fact_1).to receive(:subject) { nil }
        end

        it 'errors returns an array with an error message' do
          expect(context_fact_1.errors.single).to match(/Subject is missing/)
        end
      end
    end

    describe 'attributes and values' do
      it 'there are 7 attributes' do
        expect(described_class.attributes.size).to eq 7
      end

      it 'there are 7 values' do
        expect(context_fact_1.values.size).to eq 7
      end
    end

    describe 'context_fact?' do
      it 'is true for ContextFact or derived from it' do
        expect(context_fact_1.context_fact?).to eq true
      end
    end
  end
end
