require 'spec_helper'

module Dbd
  describe Fact do
    let(:provenance_subject) { ProvenanceFact.new_subject }
    let(:subject) { described_class.new_subject }
    let(:data_predicate)  { "http://example.org/test/name" }
    let(:string_object_1)  { "Gandhi" }
    let(:string_object_2)  { "Mandela" }
    let(:id_class) { Fact::ID }
    let(:subject_class) { Fact::Subject }
    let(:fact_1) { Factories::Fact.fact_1(provenance_subject) }
    let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_subject) }

    describe ".new_subject" do
      it "creates a new (random) subject" do
        described_class.new_subject.should be_a(subject_class)
        fact_2_with_subject.provenance_subject.should be_a(provenance_subject.class)
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

      it "a nil predicate raises ArgumentError" do
        lambda do
          described_class.new(
            provenance_subject,
            subject,
            nil,
            string_object_1)
        end . should raise_error ArgumentError
      end

      it "a nil object raises ArgumentError" do
        lambda do
          described_class.new(
            provenance_subject,
            subject,
            data_predicate,
            nil)
        end . should raise_error ArgumentError
      end
    end

    describe "valid?" do
      it "the factory isi valid?" do
        fact_2_with_subject.should be_valid
      end

      it "without provenance_subject is not valid?" do
        fact_2_with_subject.stub(:provenance_subject).and_return(nil)
        fact_2_with_subject.should_not be_valid
      end

      it "without subject is not valid?" do
        fact_2_with_subject.stub(:subject).and_return(nil)
        fact_2_with_subject.should_not be_valid
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

    describe "#dup_with_subject" do

      let (:new_fact) do
        fact_1.dup_with_subject(subject)
      end

      it "is a different instance" do
        new_fact.should_not be_equal(fact_1)
      end

      it "is from the same class" do
        new_fact.should be_a(fact_1.class)
      end

      it "has copied over the other attributes except :id, :time_stamp" do
        (fact_1.class.attributes - [:id, :time_stamp, :subject]).each do |attr|
           new_fact.send(attr).should == fact_1.send(attr)
         end
      end

      it "has set the subject to the Resource subject" do
        fact_1.subject.should_not == new_fact.subject # double check
        new_fact.subject.should == subject
      end
    end

    describe "update_provenance_subjects" do
      it "sets the value for provenance_subject to true for a fact" do
        h = {}
        fact_1.update_provenance_subjects(h)
        h[fact_1.provenance_subject].should == true
      end
    end

    describe "factory works" do
      it "with explicit provenance_subject" do
        fact_2_with_subject.provenance_subject.should be_a(provenance_subject.class)
        fact_2_with_subject.subject.should be_a(subject.class)
        fact_2_with_subject.predicate.should be_a(data_predicate.class)
        fact_2_with_subject.object.should be_a(string_object_1.class)
      end

      it "without explicit provenance_subject" do
        Factories::Fact.fact_1.provenance_subject.should be_nil
      end

      it "fact_2_with_subject should not raise_error" do
        Factories::Fact.fact_2_with_subject
      end

      it "fact_3_with_subject should not raise_error" do
        Factories::Fact.fact_3_with_subject
      end

      describe "data_fact" do
        describe "without arguments" do
          it "has empty provenance_subject" do
            Factories::Fact.data_fact.provenance_subject.should be_nil
          end

          it "has empty subject" do
            Factories::Fact.data_fact.subject.should be_nil
          end
        end

        describe "with provenance_subject" do
          it "has provenance_subject" do
            Factories::Fact.data_fact(provenance_subject).
              provenance_subject.should == provenance_subject
          end

          it "has empty subject" do
            Factories::Fact.data_fact(provenance_subject).subject.should be_nil
          end
        end

        describe "with provenance_subject and subject" do
          it "has provenance_subject" do
            Factories::Fact.data_fact(provenance_subject, subject).
              provenance_subject.should == provenance_subject
          end

          it "has subject" do
            Factories::Fact.data_fact(provenance_subject, subject).
              subject.should == subject
          end
        end
      end
    end
  end
end
