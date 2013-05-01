require 'spec_helper'

module Dbd
  module Graph
    describe Base do

      let(:fact_origin_collection_1) { Factories::FactOrigin::Collection.me_tijd }
      let(:fact_origin_collection_special) { Factories::FactOrigin::Collection.special }
      let(:fact_origin_1) { Factories::FactOrigin.me }
      let(:data_fact_collection_1_2) { Factories::DataFact::Collection.data_fact_1_2(fact_origin_1.id) }

      describe "create a graph" do
        it "does not fail" do
          described_class.new # should_not raise_error
        end
      end

      describe "#to_fact_origin_CSV" do
        it "returns a string" do
          subject.to_fact_origin_CSV.should be_a(String)
        end

        it "returns a string in UTF-8 encoding" do
          subject.to_fact_origin_CSV.encoding.should == Encoding::UTF_8
        end

        it "returns a string with comma's" do
          subject.fact_origin_collections << fact_origin_collection_1
          subject.to_fact_origin_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
        end

        describe "with a single fact_origin collection" do

          before do
            subject.fact_origin_collections << fact_origin_collection_1
          end

          it "has two lines" do
            subject.to_fact_origin_CSV.lines.size.should == 2
          end

          it "ends with a newline" do
            subject.to_fact_origin_CSV.lines.last[-1].should == "\n"
          end
        end

        describe "has all properties of the fact_origin_collection" do

          before do
            subject.fact_origin_collections << fact_origin_collection_1
          end

          let(:first_line) do
            subject.to_fact_origin_CSV.lines.to_a.first.chomp
          end

          it "has id as first value" do
            first_line.split(',')[0].should match(/"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"/)
          end

          it "has context as second value" do
            first_line.split(',')[1].should == '"public"'
          end

          it "has original_source as third value" do
            first_line.split(',')[2].should == '"http://example.org/foo"'
          end

          it "has created_by as 4th value" do
            first_line.split(',')[3].should == '"peter_v"'
          end

          it "has entered_by as 5th value" do
            first_line.split(',')[4].should == '"peter_v"'
          end

          it "has entered_by as 6th value" do
            first_line.split(',')[5].should == '"Copyright 2013 peter_v; all rights reserved"'
          end

          it "has created_at as 7th value" do
            first_line.split(',')[6].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has entered_at as 8th value" do
            first_line.split(',')[7].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has valid_from as 9th value" do
            first_line.split(',')[8].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has valid_until as 10th value" do
            first_line.split(',')[9].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end
        end

        describe "handles comma, double quote and newline correctly" do

          before do
            subject.fact_origin_collections << fact_origin_collection_special
          end

          it "has original_source with special characters and double quote escaped" do
            subject.to_fact_origin_CSV.should match(/"this has a comma , a newline \n and a double quote """/)
          end
        end
      end

      describe "#to_fact_CSV" do
        it "returns a string" do
          subject.to_fact_CSV.should be_a(String)
        end

        it "returns a string in UTF-8 encoding" do
          subject.to_fact_CSV.encoding.should == Encoding::UTF_8
        end

        it "returns a string with comma's" do
          subject.fact_collections << data_fact_collection_1_2
          subject.to_fact_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
        end

        describe "with a single fact collection" do

          before do
            subject.fact_collections << data_fact_collection_1_2
          end

          it "has two lines" do
            subject.to_fact_CSV.lines.size.should == 2
          end

          it "ends with a newline" do
            subject.to_fact_CSV.lines.last[-1].should == "\n"
          end
        end

        describe "has all properties of the fact_collection" do

          before do
            subject.fact_collections << data_fact_collection_1_2
          end

          let(:first_line) do
            subject.to_fact_CSV.lines.to_a.first.chomp
          end

          it "has id (a uuid) as first value" do
            first_line.split(',')[0].should match(/"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"/)
          end

          it "has time_stamp as second value" do
            first_line.split(',')[1].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has fact_origin_1.id as third value" do
            first_line.split(',')[2].should == "\"#{fact_origin_1.id.to_s}\""
          end

          it "has subject_id as 4th value" do
            first_line.split(',')[3].should match(/"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"/)
          end

          it "has data_property as 5th value" do
            first_line.split(',')[4].should == '"http://example.org/test/name"'
          end

          it "has object as 6th value" do
            first_line.split(',')[5].should == '"The great gatzbe"'
          end
        end

        describe "handles comma, double quote and newline correctly" do

          before do
            subject.fact_origin_collections << fact_origin_collection_special
          end

          it "has original_source with special characters and double quote escaped" do
            subject.to_fact_origin_CSV.should match(/"this has a comma , a newline \n and a double quote """/)
          end
        end
      end
    end
  end
end
