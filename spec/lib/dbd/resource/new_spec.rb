require 'spec_helper'

module Dbd
  describe Resource do

    let(:provenance_subject) { TestFactories::ProvenanceResource.provenance_resource.subject }

    let(:resource) { described_class.new(provenance_subject: provenance_subject) }

    describe '.new_subject' do
      it 'returns a Fact#new_subject' do
        described_class.new_subject.should be_a(Fact.new_subject.class)
      end
    end

    describe '.new' do
      describe 'with a provenance_subject argument' do
        it 'has created a subject' do
          resource.subject.should be_a(described_class.new_subject.class)
        end

        it 'has stored the provenance_subject' do
          resource.provenance_subject.should == provenance_subject
        end
      end

      describe 'with an explicit subject argument' do
        it 'has stored the given subject' do
          explicit_subject = described_class.new_subject
          described_class.new(
            subject: explicit_subject,
            provenance_subject: provenance_subject).subject.should == explicit_subject
        end
      end

      describe 'with a nil provenance_subject argument' do
        it 'raises a ProvenanceError' do
          lambda { described_class.new(provenance_subject: nil) } .
            should raise_error ProvenanceError
        end
      end
    end
  end
end
