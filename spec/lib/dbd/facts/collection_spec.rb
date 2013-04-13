require 'spec_helper'

module Dbd
  module Facts
    describe Collection do
      let(:fact_origin_id) {Factories::FactOrigin.me.id}
      let(:subject_id) {Helpers::TempUUID.new}

      let(:fact_1) {Fact.new(fact_origin_id, subject_id)}
      let(:fact_2) {Fact.new(fact_origin_id, subject_id)}

      describe "create a facts collection" do
        it "new does not fail" do
          subject.should_not be_nil
        end

        it "the collection is not an array" do
          subject.should_not be_a(Array)
        end

        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
        end

        it "adding an element works" do
          subject << fact_1
          subject.count.should == 1
        end

        it "other functions (e.g. []) do not work" do
          subject << fact_1
          subject << fact_2
          lambda {subject[1]} . should raise_exception NoMethodError
        end
      end

      describe "newest_time_stamp" do
        it "returns nil for empty collection" do
          subject.newest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_1
          subject.newest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the newest time_stamp" do
          subject << fact_1
          subject << fact_2
          fact_1.time_stamp.should_not == fact_2.time_stamp
          subject.newest_time_stamp.should == fact_2.time_stamp
        end
      end

      describe "validate that only 'newer' elements are added" do

        it "adding an element with a newer time_stamp succeeds" do
          fact_1
          fact_2
          subject << fact_1
          subject << fact_2
        end

        it "adding an element with an older time_stamp fails" do
          fact_1
          fact_2
          subject << fact_2
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end

        it "adding an element with ani equal time_stamp fails" do
          fact_1
          subject << fact_1
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end
      end
    end
  end
end
