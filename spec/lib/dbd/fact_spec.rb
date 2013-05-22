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
        end . should raise_error PredicateError
      end

      it "a nil object raises ObjectError" do
        lambda do
          described_class.new(
            predicate: data_predicate,
            object: nil)
        end . should raise_error ObjectError
      end
    end

    describe "time_stamp=" do

      it "checks the type (too easy to try to give a Time arg" do
        lambda { fact_1.time_stamp = Time.now } . should raise_error(ArgumentError)
      end

      describe "set_once" do

        let(:time_stamp_now) { TimeStamp.new }

        it "can be set when nil" do
          fact_1.time_stamp = time_stamp_now
          fact_1.time_stamp.should == time_stamp_now
        end

        describe "setting it two times" do
          it "with a different value raises a SetOnceError" do
            fact_1.time_stamp = time_stamp_now
            lambda { fact_1.time_stamp = (time_stamp_now+1) } . should raise_error SetOnceError
          end
        end
      end
    end

    describe "errors" do
      it "the factory has no errors" do
        fact_2_with_subject.errors.should be_empty
      end

      describe "without provenance_subject" do

        before(:each) do
          fact_2_with_subject.stub(:provenance_subject).and_return(nil)
        end

        it "errors returns an array with 1 error message" do
          fact_2_with_subject.errors.single.should match(/Provenance subject is missing/)
        end
      end

      describe "without subject" do

        before(:each) do
          fact_2_with_subject.stub(:subject).and_return(nil)
        end

        it "errors returns an array with an errorm message" do
          fact_2_with_subject.errors.single.should match(/Subject is missing/)
        end
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

    describe "update_used_provenance_subjects" do
      it "sets the value for provenance_subject to true for a fact" do
        h = {}
        fact_1.update_used_provenance_subjects(h)
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
