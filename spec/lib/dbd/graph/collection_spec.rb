require 'spec_helper'

module Dbd
  module Graph
    describe Collection do

      let(:provenance_fact_collection_1) { Factories::Fact::Collection.provenance_facts }
      let(:fact_1) { Factories::Fact.fact_1 }
      let(:fact_collection_1_2) { Factories::Fact::Collection.fact_1_2 }

      describe "create a graph_collection" do
        it "new does not fail" do
          subject.should_not be_nil
        end
      end

      describe "adding a collection" do
        it "adding a provenance_fact_collection works" do
          subject << provenance_fact_collection_1
          subject.count.should == 1
        end

        it "adding 2 provenance_fact_collections fails" do
          subject << provenance_fact_collection_1
          lambda { subject << provenance_fact_collection_1 } . should raise_error(Collection::InternalError)
        end

        it "adding a fact_collection works" do
          subject << fact_collection_1_2
          subject.count.should == 1
        end

        it "adding 2 fact_collections fails" do
          subject << fact_collection_1_2
          lambda { subject << fact_collection_1_2 } . should raise_error(Collection::InternalError)
        end
      end

      describe "index related functions from ArrayCollection do not leak into the API" do
        it "add_and_return_index is private" do
          lambda { subject.add_and_return_index(fact_collection_1_2) } . should raise_error(NoMethodError)
        end

        it "[] is private" do
          lambda { subject[0] } . should raise_error(NoMethodError)
        end
      end

      describe "newest_time_stamp" do
        it "returns nil for empty collection" do
          subject.newest_time_stamp.should be_nil
        end

        it "also returns time_stamp for provenance_facts in the collection" do
          subject << provenance_fact_collection_1
          subject.newest_time_stamp.should == provenance_fact_collection_1.last.time_stamp
        end

        it "returns a time_stamp" do
          subject << fact_collection_1_2
          subject.newest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the newest time_stamp" do
          subject << fact_collection_1_2
          subject.newest_time_stamp.should == fact_collection_1_2.last.time_stamp
        end
      end

      describe "oldest_time_stamp" do
        it "returns nil for empty collection" do
          subject.oldest_time_stamp.should be_nil
        end

        it "also returns time_stamp for provenance_facts in the collection" do
          subject << provenance_fact_collection_1
          subject.oldest_time_stamp.should == provenance_fact_collection_1.first.time_stamp
        end

        it "returns a time_stamp" do
          subject << fact_collection_1_2
          subject.oldest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the oldest time_stamp" do
          subject << fact_collection_1_2
          subject.oldest_time_stamp.should == fact_collection_1_2.first.time_stamp
        end
      end
    end
  end
end
