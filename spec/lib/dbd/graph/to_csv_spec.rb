# encoding=utf-8
require 'spec_helper'

module Dbd
  describe Graph do

    def new_subject
      Fact.factory.new_subject
    end

    let(:context_facts) { TestFactories::Fact::Collection.context_facts(new_subject) }
    let(:context_fact_1) { context_facts.first }
    let(:fact_2_3) { TestFactories::Fact::Collection.fact_2_3(context_fact_1.subject) }
    let(:fact_special_characters) { TestFactories::Fact::fact_with_special_chars(context_fact_1.subject, new_subject) }

    let(:subject_valid_regexp) { Fact::Subject.valid_regexp }
    let(:id_valid_regexp) { Fact::ID.valid_regexp }
    let(:time_stamp_valid_regexp) { TimeStamp.valid_regexp }

    describe '#to_CSV with only context_facts' do
      before do
        context_facts.each do |context_fact|
          subject << context_fact
        end
      end

      it "returns a string" do
        subject.to_CSV.should be_a(String)
      end

      it 'returns a string in UTF-8 encoding' do
        subject.to_CSV.encoding.should == Encoding::UTF_8
      end

      it "returns a string with comma's" do
        subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]*","[^",]+"/)
      end

      describe 'with a single context_fact collection' do
        it 'has three logical lines (but one with embedded newline)' do
          subject.to_CSV.lines.count.should == 3
        end

        it 'ends with a newline' do
          subject.to_CSV.lines.to_a.last[-1].should == "\n"
        end
      end

      describe 'has all attributes of the context_collection' do

        let(:first_line) do
          subject.to_CSV.lines.to_a.first.chomp
        end

        it 'has time_stamp as first value' do
          first_line.split(',')[0][1..-2].should match(time_stamp_valid_regexp)
        end

        it 'has id (a Fact::ID) as second value' do
          first_line.split(',')[1].gsub(/"/, '').should match(id_valid_regexp)
        end

        it 'has an empty third value (signature of a context_fact)' do
          first_line.split(',')[2].should == '""'
        end

        it 'has subject as 4th value' do
          first_line.split(',')[3].gsub(/"/, '').should match(subject_valid_regexp)
        end

        it 'has data_predicate as 5th value' do
          first_line.split(',')[4].should == '"context:visibility"'
        end

        it 'has object_type as 6th value' do
          first_line.split(',')[5].should == '"s"'
        end

        it 'has object as 7th value' do
          first_line.split(',')[6].should == '"public"'
        end
      end

      describe 'handles comma, double quote and newline correctly' do
        it 'has original_source with special characters and double quote escaped' do
          subject.to_CSV.should match(/"this has a comma , a newline \\n and a double quote """/)
        end
      end
    end

    describe '#to_CSV with only facts' do
      before do
        fact_2_3.each_with_index do |fact, index|
          subject << fact
         end
      end

      it 'returns a string' do
        subject.to_CSV.should be_a(String)
      end

      it 'returns a string in UTF-8 encoding' do
        subject.to_CSV.encoding.should == Encoding::UTF_8
      end

      it "returns a string with comma's" do
        subject.to_CSV.should match(/\A"[^",]+","[^",]+","[^",]+"/)
      end

      describe 'with a single fact collection' do
        it 'has two lines' do
          subject.to_CSV.lines.count.should == 2
        end

        it 'ends with a newline' do
          subject.to_CSV.lines.to_a.last[-1].should == "\n"
        end
      end

      describe 'has all attributes of the fact_collection' do

        let(:first_line) do
          subject.to_CSV.lines.to_a.first.chomp
        end

        it 'has time_stamp as first value' do
          first_line.split(',')[0][1..-2].should match(time_stamp_valid_regexp)
        end

        it 'has id (a Fact::ID) as second value' do
          first_line.split(',')[1].gsub(/"/, '').should match(id_valid_regexp)
        end

        it 'has context_fact_1.subject as third value' do
          first_line.split(',')[2].should == "\"#{context_fact_1.subject.to_s}\""
        end

        it 'has subject as 4th value' do
          first_line.split(',')[3].gsub(/"/, '').should match(subject_valid_regexp)
        end

        it 'has data_predicate as 5th value' do
          first_line.split(',')[4].should == '"http://example.org/test/name"'
        end

        it 'has object_type as 6th value' do
          first_line.split(',')[5].should == '"s"'
        end

        it 'has object as 7th value' do
          first_line.split(',')[6].should == '"Mandela"'
        end
      end
    end

    describe '#to_CSV with context_facts and facts' do

      before do
        context_facts.each do |context_fact|
          subject << context_fact
        end
        fact_2_3.each do |fact|
          subject << fact
         end
      end

      it 'has 5 lines' do
        subject.to_CSV.lines.count.should == 5
      end
    end

    describe '#to_CSV_file' do

      before do
        context_facts.each do |context_fact|
          subject << context_fact
        end
        fact_2_3.each do |fact|
          subject << fact
        end
        subject << fact_special_characters
      end

      it 'has six lines' do
        filename = 'data/foo.csv'
        subject.to_CSV_file(filename)
        File.open(filename) do |f|
          f.readlines.count.should == 6
        end
      end

      it 'reads back UTF-8 characters correctly' do
        filename = 'data/foo.csv'
        subject.to_CSV_file(filename)
        File.open(filename) do |f|
          f.readlines.detect{|l| l.match(%r{really with a comma, a double quote "" and a non-ASCII char éà Über.})}.should_not be_nil
        end
      end
    end
  end
end
