require 'spec_helper'

module Dbd
  module Facts
    describe Collection do
      let(:fact_origin_id) {Factories::FactOrigin.me.id}
      let(:subject_id) {Helpers::TempUUID.new}

      let(:fact_1) {Fact.new(fact_origin_id, subject_id)}
      let(:fact_2) {Fact.new(fact_origin_id, subject_id)}

      describe "create a facts collection" do
        it "has a collection" do
          subject.collection.should_not be_nil
        end
      end
    end
  end
end
