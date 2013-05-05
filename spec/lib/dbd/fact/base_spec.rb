require 'spec_helper'

module Dbd
  module Fact
    describe Base do
      let(:fact_origin_id) { Factories::FactOrigin.me.id }
      let(:subject) { UUIDTools::UUID.random_create }
      let(:data_property)  { "http://example.org/test/name" }
      let(:string_object_1)  { "Gandhi" }
      let(:string_object_2)  { "Mandela" }

      # fact_1 is a data_fact
      let(:fact_1) do
        described_class.new(
          fact_origin_id,
          subject,
          data_property,
          string_object_1)
      end

      # fact_2 may be an object_fact later
      let(:fact_2) do
        described_class.new(
          fact_origin_id,
          subject,
          data_property,
          string_object_2)
      end

      describe "create a fact" do
        it "has a unique id (UUID)" do
          fact_1.id.should be_a(UUIDTools::UUID)
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

        it "new needs a fact_origin id" do
          fact_1.fact_origin_id.should == fact_origin_id
        end

        it "new stores a subject" do
          fact_1.subject.should == subject
        end
      end

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new stores a property" do
            fact_1.property.should == data_property
          end

          it "new stores a String object" do
            fact_1.object.should == string_object_1
          end
        end
      end

      describe "attributes and values" do
        it "there are 6 attributes" do
          described_class.attributes.size.should == 6
        end

        it "first attribute is :id" do
          described_class.attributes.first.should == :id
        end

        it "there are 6 values" do
          fact_1.values.size.should == 6
        end

        it "second value is a time_stamp" do
          fact_1.values[1].should be_a(Time)
        end
      end

      describe "factory works" do
        it "without fact_origin_id" do
          fact_1 = Factories::Fact.fact_1
          fact_1.fact_origin_id.should be_a(fact_origin_id.class)
          fact_1.subject.should be_a(subject.class)
          fact_1.property.should be_a(data_property.class)
          fact_1.object.should be_a(string_object_1.class)
        end

        it "with an explicit fact_origin_id" do
          fact_origin_id_1 = fact_origin_id
          fact_1 = Factories::Fact.fact_1(fact_origin_id_1)
          fact_1.fact_origin_id.should == fact_origin_id_1
        end
      end
    end
  end
end
