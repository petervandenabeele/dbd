require 'spec_helper'

module Dbd
  module Helpers
    describe ArrayCollection do

      let(:element_1) {:element_1}
      let(:subject) do
        o = Object.new
        o.extend(described_class)
        o.send(:initialize)
        o
      end

      describe "create an elements collection" do
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
          subject << element_1
          subject.count.should == 1
        end

        it "other functions (e.g. []) do not work" do
          subject << element_1
          lambda {subject[1]} . should raise_exception NoMethodError
        end
      end
    end
  end
end
