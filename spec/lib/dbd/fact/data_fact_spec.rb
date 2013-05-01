require 'spec_helper'

module Dbd
  module Fact
    describe DataFact do

      let(:fact_origin_id) {Factories::FactOrigin.me.id}
      let(:subject_id) {Factories::Fact.fact_1.subject_id}
      let(:data_property) {"http://example.org/test/name"}
      let(:string_object) {"The great gatzbe"}

      let(:data_fact) {described_class.new(fact_origin_id, subject_id, data_property, string_object)}

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new stores a property" do
            data_fact.property.should == data_property
          end

          it "new stores a String object" do
            data_fact.object.should == string_object
          end
        end
      end

      describe "factory works" do
        it "without fact_origin_id" do
          data_fact_1 = Factories::DataFact.data_fact_1
          data_fact_1.fact_origin_id.should be_a(Factories::FactOrigin.me.id.class)
          data_fact_1.subject_id.should be_a(Factories::Fact.fact_1.subject_id.class)
          data_fact_1.property.should be_a(String)
          data_fact_1.object.should be_a(String)
        end
      end
    end
  end
end
