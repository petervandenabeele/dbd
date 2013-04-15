require 'spec_helper'

module Dbd
  module Helpers
    describe HashCollection do

      let(:element_1) {OpenStruct.new(id: :key_1)}
      let(:subject) do
        o = Object.new
        o.extend(described_class)
        o.send(:initialize)
        o
      end

      describe "create an elements collection :" do
        it "new does not fail" do
          subject.should_not be_nil
        end

        it "the collection is not a Hash" do
          subject.should_not be_a(Hash)
        end

        it "the collection has Enumerable methods" do
          subject.map #should_not raise_exception
        end

        it "adding an element works" do
          subject << element_1
          subject.count.should == 1
        end

        it "reading an element works" do
          subject << element_1
          subject[element_1.id].should == element_1
        end

      end
    end
  end
end
