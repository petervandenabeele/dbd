require 'spec_helper'

module Dbd
  module Facts
    describe Fact do
      let(:fact_origin_id) {Factories::FactOrigin.me.id}
      let(:subject_id) {Helpers::TempUUID.new}

      let(:fact_1) {described_class.new(fact_origin_id, subject_id)}
      let(:fact_2) {described_class.new(fact_origin_id, subject_id)}

      describe "create a fact" do
        it "has a unique id (UUID)" do
          fact_1.id.should be_a(Helpers::TempUUID)
        end

        it "two facts have different id" do
          fact_1.id.should_not == fact_2.id
        end

        it "has a very fine grained time stamp" do
          fact_1.time_stamp.should be_a(Time)
        end

        it "the time_stamps of 2 consecutive created facts should be different" do
          fact_1.time_stamp.should < fact_2.time_stamp
        end

        it "new needs needs a fact_origin id" do
          fact_1.fact_origin_id.should == fact_origin_id
        end

        it "new stores a subject_id" do
          fact_1.subject_id.should == subject_id
        end
      end
    end
  end
end
