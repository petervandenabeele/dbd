require 'spec_helper'

module Dbd
  module Facts
    describe DataFact do
      it "class exist" do
        described_class # should not raise error
      end

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new does not raise exception" do
            subject # should_not raise_exception
          end

          it "has a unique id (UUID)" do
            subject.id.should be_a(Helpers::TempUUID)
          end

          it "two data_facts have different id" do
            data_fact_1 = described_class.new
            data_fact_2 = described_class.new
            data_fact_1.id.should_not == data_fact_2
          end

          it "has a very fine grained time stamp" do
            subject.time_stamp.should be_a(Time)
          end

          it "the time_stamps of 2 consecutive created facts should be different" do
            data_fact_1 = described_class.new
            data_fact_2 = described_class.new
            data_fact_1.time_stamp.should < data_fact_2.time_stamp
          end
        end
      end
    end
  end
end
