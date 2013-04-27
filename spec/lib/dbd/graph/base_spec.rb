require 'spec_helper'

module Dbd
  module Graph
    describe Base do
      describe "create a graph" do
        it "does not fail" do
          described_class.new # should_not raise_error
        end
      end

      describe "#collections" do
        describe "has enumerable methods" do
          it "empty for new object" do
            subject.collections.count.should == 0
          end

          it "adding 1 entry works" do
            subject.collections << :a
            subject.collections.count.should == 1
          end

          it "adding 2 entries works" do
            subject.collections << :a
            subject.collections.count.should == 1
            subject.collections << :b
            subject.collections.count.should == 2
            subject.collections.to_a.should == [:a, :b]
          end
        end
      end

      describe "#to_CSV" do
        it "returns a string" do
          subject.to_CSV.should be_a(String)
        end

        it "returns a string in UTF-8 encoding" do
          subject.to_CSV.encoding.should == Encoding::UTF_8
        end

        it "returns a string with comma's" do
          subject.collections << Factories::FactOrigin::Collection.me_tijd
          subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
        end

        describe "with a single fact_origin collection" do

          before do
            subject.collections << Factories::FactOrigin::Collection.me_tijd
          end

          it "has two lines" do
            subject.to_CSV.lines.size.should == 2
          end

          it "ends with a newline" do
            subject.to_CSV.lines.last[-1].should == "\n"
          end
        end

        describe "with two fact_origin collections" do
          it "has four lines" do
            subject.collections << Factories::FactOrigin::Collection.me_tijd
            subject.collections << Factories::FactOrigin::Collection.me_tijd
            subject.to_CSV.lines.size.should == 4
          end
        end

        describe "has all properties of the fact_origin_collection" do

          before do
            subject.collections << Factories::FactOrigin::Collection.me_tijd
          end

          let(:first_line) do
            subject.to_CSV.lines.to_a.first.chomp
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

          it "has created_at as 6th value" do
            first_line.split(',')[5].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has entered_at as 7th value" do
            first_line.split(',')[6].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has valid_from as 8th value" do
            first_line.split(',')[7].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end

          it "has valid_until as 9th value" do
            first_line.split(',')[8].should match(/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d UTC"/)
          end
        end

        describe "handles comma, double quote and newline correctly" do

          before do
            subject.collections << Factories::FactOrigin::Collection.special
          end

          it "has original_source with special characters and double quote escaped" do
            subject.to_CSV.should match(/"this has a comma , a newline \n and a double quote """/)
          end
        end
      end
    end
  end
end
