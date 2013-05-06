require 'spec_helper'

module Dbd
  module Helpers
    describe ArrayCollection do

      let(:element_1) {:element_1}
      let(:element_2) {:element_2}
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
          # do not derive from Ruby standard classes
          subject.should_not be_a(Array)
        end
      end

      describe "accessor functions" do
        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
          subject.first #should_not raise_exception
        end

        it "adding an element works" do
          subject << element_1
          subject.count.should == 1
        end

        it "other functions (e.g. pop) do not work" do
          subject << element_1
          lambda {subject.pop} . should raise_exception NoMethodError
        end

        it "getting 1 element by array index works" do
          subject << element_1
          subject[0].should_not be_nil
        end

        describe "<< returns the index of the inserted element" do
          it "works for 1 element" do
            index = (subject << element_1)
            subject[index].should == element_1
          end
          it "works for 2 elements" do
            subject << element_1
            index = (subject << element_2)
            subject[index].should == element_2
          end
        end

        describe "last" do
          it "returns nil on empty collection" do
            subject.last.should be_nil
          end

          it "returns the last element" do
            subject << element_1
            subject << element_2
            subject.last.should == element_2
          end
        end
      end
    end
  end
end
