require 'spec_helper'

module Dbd
  describe Fact do
    let(:provenance_subject) { ProvenanceFact.new_subject }
    let(:fact_1) { Factories::Fact.fact_1(provenance_subject) }
    let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_subject) }
    let(:data_predicate)  { "http://example.org/test/name" }
    let(:string_object_1)  { "Gandhi" }
    let(:id_class) { Fact::ID }
    let(:subject_class) { Fact::Subject }
    let(:forced_id) { described_class.new_id }
    let(:subject) { described_class.new_subject }
    let(:fact_with_forced_id) { Factories::Fact.fact_with_forced_id(forced_id) }
    let(:time_stamp) { TimeStamp.new }
    let(:fact_with_time_stamp) { Factories::Fact.fact_with_time_stamp(time_stamp) }
    let(:fact_with_incorrect_time_stamp) { Factories::Fact.fact_with_time_stamp(time_stamp.time) }

    describe ".new_subject" do
      it "creates a new (random) subject" do
        described_class.new_subject.should be_a(subject_class)
      end

      it "creating a second one is different" do
        subject_1 = described_class.new_subject
        subject_2 = described_class.new_subject
        subject_1.should_not == subject_2
      end

      it "takes an options hash" do
        described_class.new_subject(uuid: subject.to_s).to_s.should == subject.to_s
      end
    end

    describe ".new_id" do
      it "creates a new (random) id" do
        described_class.new_id.should be_a(id_class)
      end

      it "creating a second one is different" do
        id_1 = described_class.new_id
        id_2 = described_class.new_id
        id_1.should_not == id_2
      end

      it "takes an options hash" do
        described_class.new_id(uuid: forced_id.to_s).to_s.should == forced_id.to_s
      end
    end

    describe "create a fact" do
      it "has a unique id (id_class)" do
        fact_1.id.should be_a(id_class)
      end

      it "two facts have different id" do
        fact_1.id.should_not == fact_2_with_subject.id
      end

      it "optionally sets the id" do
        fact_with_forced_id.id.should == forced_id
      end

      it "optionally sets the time_stamp" do
        fact_with_time_stamp.time_stamp.should == time_stamp
      end

      it "setting the time_stamp to a non TimeStamp raises ArgumentError" do
        lambda{ fact_with_incorrect_time_stamp }.should raise_error ArgumentError
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
