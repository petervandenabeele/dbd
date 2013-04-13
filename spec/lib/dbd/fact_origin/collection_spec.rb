require 'spec_helper'

module Dbd
  module FactOrigin
    describe Collection do
      let(:fact_origin_1) {Factories::FactOrigin.me}
      let(:fact_origin_2) {Factories::FactOrigin.tijd}

      describe "create a fact_origins collection" do
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
          subject << fact_origin_1
          subject.count.should == 1
        end

        it "other functions (e.g. []) do not work" do
          subject << fact_origin_1
          subject << fact_origin_2
          lambda {subject[1]} . should raise_exception NoMethodError
        end
      end

    end
  end
end
