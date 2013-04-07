require 'spec_helper'

module Dbd
  module Facts
    describe DataFact do
      it "class exist" do
        described_class # should not raise error
      end

      let(:fact_origin_id) {:fact_origin_id}
      let(:data_fact) {described_class.new(fact_origin_id)}

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new does not raise exception" do
            data_fact # should_not raise_exception
          end

          it "has a unique id (UUID)" do
            data_fact.id.should be_a(Helpers::TempUUID)
          end

          it "two data_facts have different id" do
            data_fact_1 = described_class.new(fact_origin_id)
            data_fact_2 = described_class.new(fact_origin_id)
            data_fact_1.id.should_not == data_fact_2
          end

          it "has a very fine grained time stamp" do
            data_fact.time_stamp.should be_a(Time)
          end

          it "the time_stamps of 2 consecutive created facts should be different" do
            data_fact_1 = described_class.new(fact_origin_id)
            data_fact_2 = described_class.new(fact_origin_id)
            data_fact_1.time_stamp.should < data_fact_2.time_stamp
          end

          it "new needs needs a fact_origin id" do
            data_fact = described_class.new(fact_origin_id)
            data_fact.fact_origin_id.should == :fact_origin_id
          end
        end
      end
    end
  end
end
