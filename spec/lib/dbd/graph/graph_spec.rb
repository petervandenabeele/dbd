require 'spec_helper'

module Dbd
  module Graph
    describe Graph do
      describe "create a graph" do
        it "does not fail" do
          described_class.new # should_not raise_error
        end
      end

      describe "has enumerable methods" do
        it "empty for new object" do
          subject.count.should == 0
        end

        it "adding 1 entry works" do
          subject << :a
          subject.count.should == 1
        end

        it "adding 2 entries works" do
          subject << :a
          subject.count.should == 1
          subject << :b
          subject.count.should == 2
          subject.to_a.should == [:a, :b]
        end
      end

      describe "to_CSV" do
        it "returns a string" do
          subject.to_CSV.should be_a(String)
        end

        it "returns a string in UTF-8 encoding" do
          subject.to_CSV.encoding.should == Encoding::UTF_8
        end

        it "returns a string with comma's" do
          subject << Factories::FactOrigin::Collection.me_tijd
          subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
        end
      end

      describe "with a single fact_origin collection" do
        it "has two lines" do
          subject << Factories::FactOrigin::Collection.me_tijd
          subject.to_CSV.lines.size.should == 2
        end

        it "ends with a newline" do
          subject << Factories::FactOrigin::Collection.me_tijd
          subject.to_CSV.lines.last[-1].should == "\n"
        end
      end

      describe "with two fact_origin collections" do
        it "has four lines" do
          subject << Factories::FactOrigin::Collection.me_tijd
          subject << Factories::FactOrigin::Collection.me_tijd
          subject.to_CSV.lines.size.should == 4
        end
      end
    end
  end
end
