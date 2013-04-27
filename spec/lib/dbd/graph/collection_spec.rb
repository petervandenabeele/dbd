require 'spec_helper'

module Dbd
  module Graph
    describe Collection do

      let(:fact_origin_collection_1) {Factories::FactOrigin::Collection.me_tijd}

      describe "create a graph_collection" do
        it "new does not fail" do
          subject.should_not be_nil
        end

        it "adding a fact_origin_collection works" do
          subject << fact_origin_collection_1
          subject.count.should == 1
        end

        it "adding 2 fact_origin_collections works" do
          subject << fact_origin_collection_1
          subject << fact_origin_collection_1
          subject.count.should == 2
        end
      end
    end
  end
end
