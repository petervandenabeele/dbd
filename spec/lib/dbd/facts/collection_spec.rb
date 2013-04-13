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
          subject << :a
          subject.count.should == 1
        end

        it "other functions (e.g. []) do not work" do
          subject << :a
          subject << :b
          lambda {subject[1]} . should raise_exception NoMethodError
        end

      end
    end
  end
end
