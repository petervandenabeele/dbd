require 'spec_helper'

module Dbd
  describe ProvenanceFact do

    let(:subject) { described_class.factory.new_subject }
    let(:id_class) { described_class.factory.new_id.class }

    let(:provenance_fact_1) do
      TestFactories::ProvenanceFact.context(subject)
    end

    let(:provenance_fact_2) do
      TestFactories::ProvenanceFact.created_by(subject)
    end

    describe '#new' do
      it 'has a unique id (new_id.class)' do
        provenance_fact_1.id.should be_a(id_class)
      end

      it 'two provenance_facts have different id' do
        provenance_fact_1.id.should_not == provenance_fact_2.id
      end

      it 'has nil provenance_subject' do
        provenance_fact_1.provenance_subject.should be_nil
      end

      it 'has correct subject' do
        provenance_fact_1.subject.should == subject
      end

      it 'has correct predicate' do
        provenance_fact_1.predicate.should == 'https://data.vandenabeele.com/ontologies/provenance#context'
      end

      it 'has correct object' do
        provenance_fact_1.object.should == 'public'
      end

      it 'raises an ProvenanceError when provenance_subject is present in options hash' do
        lambda { described_class.new(
          provenance_subject: subject,
          predicate: 'test',
          object: 'test') } .
            should raise_error ProvenanceError
      end
    end
  end
end
