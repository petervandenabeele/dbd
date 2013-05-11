require 'spec_helper'

module Dbd
  describe Resource do
    describe ".new" do
      describe "without arguments" do
        it "does_not raise_error" do
          subject
        end

        it "has a nil subject" do
          subject.subject.should be_nil
        end
      end

      describe "with a subject argument" do

        let(:fact_subject) { Fact.new_subject }
        let(:resource_with_subject) { described_class.new(fact_subject) }

        it "has the fact_subject" do
          resource_with_subject.subject.should == fact_subject
        end
      end
    end

    describe "the collection" do

      let(:fact_1) { Factories::Fact.fact_1 }
      let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject }
      let(:fact_3_with_subject) { Factories::Fact.fact_3_with_subject }

      it "enumerable functions work" do
        subject.to_a.should == []
      end

      it "<< can add a fact" do
        subject << fact_1
        subject.to_a.should == [fact_1]
      end

      it "<< can add two facts" do
        subject << fact_2_with_subject
        subject << fact_3_with_subject
        subject.to_a.should == [fact_2_with_subject, fact_3_with_subject]
      end
    end
  end
end