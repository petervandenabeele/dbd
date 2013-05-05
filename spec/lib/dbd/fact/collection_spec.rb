require 'spec_helper'

module Dbd
  module Fact
    describe Collection do

      let(:fact_1) {Factories::Fact.fact_1}
      let(:fact_2) {Factories::Fact.fact_2}

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
          subject.newest_time_stamp.should == fact_2.time_stamp
        end
      end

      describe "validate that only 'newer' elements are added" do
        it "adding an element with a newer time_stamp succeeds" do
          subject << fact_1
          subject << fact_2
        end

        it "adding an element with an older time_stamp fails" do
          fact_1 # will be older then fact_2
          subject << fact_2
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end

        it "adding an element with an equal time_stamp fails" do
          fact_1
          subject << fact_1
          lambda { subject << fact_1 } . should raise_error(Collection::OutOfOrderError)
        end
      end

      describe "oldest_time_stamp" do
        it "returns nil for empty collection" do
          subject.oldest_time_stamp.should be_nil
        end

        it "returns a time_stamp" do
          subject << fact_1
          subject.oldest_time_stamp.should be_a(fact_1.time_stamp.class)
        end

        it "returns the oldest time_stamp" do
          subject << fact_1
          subject << fact_2
          subject.oldest_time_stamp.should == fact_1.time_stamp
        end
      end

      describe "Factories::Fact::Collection" do
        it ".fact_1_2 does not fail" do
          Factories::Fact::Collection.fact_1_2 #should_not raise_error
        end

        it ".fact_3_4 does not fail" do
          Factories::Fact::Collection.fact_3_4 #should_not raise_error
        end
      end


      describe "Factories::Fact::Collection.fact_1_2" do

        let(:subject) { Factories::Fact::Collection.fact_1_2 }

        it "does not fail" do
          subject #should_not raise_error
        end

        it "is a Fact::Collection" do
          subject.should(be_a(Collection))
        end

        it "it has 2 entries" do
          subject.count.should == 2
        end

        it "all entries should be a Fact::Base" do
          subject.each do |e|
            e.should be_a(Fact::Base)
          end
        end

        it "uses fact_origin_id if supplied" do
          fact_origin_id = Factories::FactOrigin.me.id
          subject = Factories::Fact::Collection.fact_1_2(fact_origin_id)
          subject.each do |fact|
            fact.fact_origin_id.should == fact_origin_id
          end
        end
      end

      describe "is_ordered?" do
        it "is true for Fact::Collection" do
          subject.is_ordered?.should be_true
        end
      end
    end
  end
end
