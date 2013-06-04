require 'spec_helper'

module Dbd
  describe Fact do
    let(:fact_1) { Factories::Fact.fact_1(provenance_subject) }
    let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_subject) }
    let(:provenance_subject) { ProvenanceFact.new_subject }
    let(:data_predicate)  { "http://example.org/test/name" }
    let(:string_object_1)  { "Gandhi" }
    let(:id_class) { Fact::ID }
    let(:subject_class) { Fact::Subject }

    describe ".new_subject" do
      it "creates a new (random) subject" do
        described_class.new_subject.should be_a(subject_class)
      end

      it "creating a second one is different" do
        subject_1 = described_class.new_subject
        subject_2 = described_class.new_subject
        subject_1.should_not == subject_2
      end
    end

    describe "create a fact" do
      it "has a unique id (id_class)" do
        fact_1.id.should be_a(id_class)
      end

      it "two facts have different id" do
        fact_1.id.should_not == fact_2_with_subject.id
      end

      it "new sets the provenance_subject" do
        fact_1.provenance_subject.should == provenance_subject
      end

      it "new sets the subject" do
        fact_2_with_subject.subject.should be_a(subject_class)
      end

      it "a nil predicate raises PredicateError" do
        lambda do
          described_class.new(
            predicate: nil,
            object: string_object_1)
        end.should raise_error(PredicateError)
      end

      it "a nil object raises ObjectError" do
        lambda do
          described_class.new(
            predicate: data_predicate,
            object: nil)
        end.should raise_error(ObjectError)
      end
    end

    describe "create fact_1" do
      describe "with a string object type" do
        it "new sets the predicate" do
          fact_1.predicate.should == data_predicate
        end

        it "new sets the object" do
          fact_1.object.should == string_object_1
        end
      end
    end

    describe "update_used_provenance_subjects" do
      it "sets the value for provenance_subject to true for a fact" do
        h = {}
        fact_1.update_used_provenance_subjects(h)
        h[fact_1.provenance_subject].should == true
      end
    end
  end
end
