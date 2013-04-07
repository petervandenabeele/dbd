require 'spec_helper'

module Dbd
  module Facts
    describe DataFact do

      let(:fact_origin_id) {:fact_origin_id}
      let(:subject_id) {Helpers::TempUUID.new}
      let(:data_property) {"http://example.org/test/name"}

      let(:data_fact) {described_class.new(fact_origin_id, subject_id, data_property)}

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new stores a property" do
            data_fact.property.should == data_property
          end
        end
      end
    end
  end
end
