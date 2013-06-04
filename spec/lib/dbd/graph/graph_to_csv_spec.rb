require 'spec_helper'

module Dbd
  describe Graph do

    def new_subject
      Fact.new_subject
    end

    let(:provenance_facts) { Factories::Fact::Collection.provenance_facts(new_subject) }
    let(:provenance_fact_1) { provenance_facts.first }
    let(:fact_2_3) { Factories::Fact::Collection.fact_2_3(provenance_fact_1.subject) }

    let(:subject_regexp) { Fact::Subject.regexp }
    let(:id_regexp) { Fact::ID.regexp }

    describe "#to_CSV with only provenance_facts" do
      before do
        provenance_facts.each_with_index do |provenance_fact, index|
          subject << provenance_fact
        end
      end

      it "returns a string" do
        subject.to_CSV.should be_a(String)
      end

      it "returns a string in UTF-8 encoding" do
        subject.to_CSV.encoding.should == Encoding::UTF_8
      end

      it "returns a string with comma's" do
        subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]*","[^",]+"/)
      end

      describe "with a single provenance_fact collection" do
        it "has three logical lines (but one with embedded newline)" do
          subject.to_CSV.lines.count.should == 4
        end

        it "ends with a newline" do
          subject.to_CSV.lines.to_a.last[-1].should == "\n"
        end
      end

      describe "has all attributes of the provenance_fact_collection" do

        let(:first_line) do
          subject.to_CSV.lines.to_a.first.chomp
        end

        it "has id (a Fact::ID) as first value" do
          first_line.split(',')[0].gsub(/"/, '').should match(id_regexp)
        end

        it "has time_stamp as second value" do
          first_line.split(',')[1].should match(TimeStamp.to_s_regexp)
        end

        it "has an empty third value (signature of a provenance_fact)" do
          first_line.split(',')[2].should == "\"\""
        end

        it "has subject as 4th value" do
          first_line.split(',')[3].gsub(/"/, '').should match(subject_regexp)
        end

        it "has data_predicate as 5th value" do
          first_line.split(',')[4].should == '"https://data.vandenabeele.com/ontologies/provenance#context"'
        end

        it "has object as 6th value" do
          first_line.split(',')[5].should == '"public"'
        end
      end

      describe "handles comma, double quote and newline correctly" do
        it "has original_source with special characters and double quote escaped" do
          subject.to_CSV.should match(/"this has a comma , a newline \n and a double quote """/)
        end
      end
    end

    describe "#to_CSV with only facts" do
      before do
        fact_2_3.each_with_index do |fact, index|
          subject << fact
         end
      end

      it "returns a string" do
        subject.to_CSV.should be_a(String)
      end

      it "returns a string in UTF-8 encoding" do
        subject.to_CSV.encoding.should == Encoding::UTF_8
      end

      it "returns a string with comma's" do
        subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
      end

      describe "with a single fact collection" do
        it "has two lines" do
          subject.to_CSV.lines.count.should == 2
        end

        it "ends with a newline" do
          subject.to_CSV.lines.to_a.last[-1].should == "\n"
        end
      end

      describe "has all attributes of the fact_collection" do

        let(:first_line) do
          subject.to_CSV.lines.to_a.first.chomp
        end

        it "has id (a Fact::ID) as first value" do
          first_line.split(',')[0].gsub(/"/, '').should match(id_regexp)
        end

        it "has time_stamp as second value" do
          first_line.split(',')[1].should match(TimeStamp.to_s_regexp)
        end

        it "has provenance_fact_1.subject as third value" do
          first_line.split(',')[2].should == "\"#{provenance_fact_1.subject.to_s}\""
        end

        it "has subject as 4th value" do
          first_line.split(',')[3].gsub(/"/, '').should match(subject_regexp)
        end

        it "has data_predicate as 5th value" do
          first_line.split(',')[4].should == '"http://example.org/test/name"'
        end

        it "has object as 6th value" do
          first_line.split(',')[5].should == '"Mandela"'
        end
      end
    end

    describe "#to_CSV with provenance_facts and facts" do

      before do
        provenance_facts.each do |provenance_fact|
          subject << provenance_fact
        end
        fact_2_3.each do |fact|
          subject << fact
         end
      end

      it "has six lines" do
        subject.to_CSV.lines.count.should == 6
      end
    end
  end
end
