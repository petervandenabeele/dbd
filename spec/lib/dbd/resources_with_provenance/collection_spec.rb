require 'spec_helper'

module Dbd
  class ResourcesWithProvenance
    describe Collection do

      let(:resource_1) { Factories::Resource.facts_resource }
      let(:resource_2) { Factories::Resource.facts_resource }

      describe ".new : " do
        it "the collection is not an array" do
          subject.should_not be_a(Array)
        end

        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
        end
      end

      describe ".methods : " do
        describe "#<< : " do
          it "adding a resource works" do
            subject << resource_1
            subject.to_a.should == [resource_1]
          end

          it "adding 2 resources works" do
            subject << resource_1
            subject << resource_2
            subject.to_a.should == [resource_1, resource_2]
          end

          it "returns self to allow chaining" do
            (subject << resource_1).should == subject
          end
        end
      end
    end
  end
end
