require 'spec_helper'

module Dbd
  describe Fact do
    let(:provenance_fact_subject) { ProvenanceFact.new_subject }
    let(:subject) { described_class.new_subject }
    let(:data_predicate)  { "http://example.org/test/name" }
    let(:string_object_1)  { "Gandhi" }
    let(:string_object_2)  { "Mandela" }
    let(:id_class) { Fact::ID }
    let(:subject_class) { Fact::Subject }
    let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_fact_subject) }

    # fact_1 is a data_fact
    let(:fact_1) do
      described_class.new(
        provenance_fact_subject,
        subject,
        data_predicate,
        string_object_1)
    end

    # fact_2 may be an object_fact later
    let(:fact_2) do
      described_class.new(
        provenance_fact_subject,
        subject,
        data_predicate,
        string_object_2)
    end

    describe ".new_subject" do
      it "creates a new (random) subject" do
        described_class.new_subject.should be_a(subject_class)
        fact_2_with_subject.provenance_fact_subject.should be_a(provenance_fact_subject.class)
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
        fact_1.id.should_not == fact_2.id
      end

      it "new sets the provenance_fact_subject" do
        fact_1.provenance_fact_subject.should == provenance_fact_subject
      end

      it "new sets the subject" do
        fact_1.subject.should == subject
      end

      it "a nil predicate raises ArgumentError" do
        lambda do
          described_class.new(
            provenance_fact_subject,
            subject,
            nil,
            string_object_1)
        end . should raise_error ArgumentError
      end

      it "a nil object raises ArgumentError" do
        lambda do
          described_class.new(
            provenance_fact_subject,
            subject,
            data_predicate,
            nil)
        end . should raise_error ArgumentError
      end
    end

    describe "complete?" do
      it "the factory is complete?" do
        fact_2_with_subject.should be_complete
      end

      it "without provenance_fact_subject is not complete?" do
        fact_2_with_subject.stub(:provenance_fact_subject).and_return(nil)
        fact_2_with_subject.should_not be_complete
      end

      it "without subject is not complete?" do
        fact_2_with_subject.stub(:subject).and_return(nil)
        fact_2_with_subject.should_not be_complete
      end
    end

    describe "create a data_fact" do
      describe "with a string object type" do
        it "new sets the predicate" do
          fact_1.predicate.should == data_predicate
        end

        it "new sets the object" do
          fact_1.object.should == string_object_1
        end
      end
    end

    describe "attributes and values" do
      it "there are 6 attributes" do
        described_class.attributes.size.should == 6
      end

      it "first attribute is :id" do
        described_class.attributes.first.should == :id
      end

      it "there are 6 values" do
        fact_1.values.size.should == 6
      end
    end

    describe "update_provenance_fact_subjects" do
      it "sets the value for provenance_fact_subject to true for a fact" do
        h = {}
        fact_1.update_provenance_fact_subjects(h)
        h[fact_1.provenance_fact_subject].should == true
      end
    end

    describe "factory works" do
      it "with explicit provenance_fact_subject" do
        fact_2_with_subject.provenance_fact_subject.should be_a(provenance_fact_subject.class)
        fact_2_with_subject.subject.should be_a(subject.class)
        fact_2_with_subject.predicate.should be_a(data_predicate.class)
        fact_2_with_subject.object.should be_a(string_object_1.class)
      end

      it "without explicit provenance_fact_subject" do
        Factories::Fact.fact_1.provenance_fact_subject.should be_nil
      end

      it "fact_2_with_subject should not raise_error" do
        Factories::Fact.fact_2_with_subject
      end

      it "fact_3_with_subject should not raise_error" do
        Factories::Fact.fact_3_with_subject
      end
    end
  end
end
