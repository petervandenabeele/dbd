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
      end

      describe "<< : " do
        it "adding an element works" do
          subject << fact_origin_1
          subject.count.should == 1
        end

        it "trying to overwrite an element raise OverwriteKeyError" do
          subject << fact_origin_1
          lambda {subject << fact_origin_1} . should raise_error(OverwriteKeyError)
        end
      end

      describe "[] : " do
        it "finds entry with correct id" do
          subject << fact_origin_1
          subject << fact_origin_2
          id_1 = fact_origin_1.id
          id_2 = fact_origin_2.id
          subject[id_1].id.should == id_1
          subject[id_2].id.should == id_2
        end
      end
    end
  end
end
