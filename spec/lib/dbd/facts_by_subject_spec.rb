require 'spec_helper'

module Dbd
  describe FactsBySubject do
    describe ".new" do
      describe "without arguments" do
        it "creates a new object" do
          subject.should be_a FactsBySubject
        end

        it "has a nil subject" do
          subject.subject.should be_nil
        end
      end

      describe "with a subject argument" do

        let(:fact_subject) { Fact.new_subject }
        let(:facts_by_subject) { described_class.new(fact_subject) }

        it "has the fact_subject" do
          facts_by_subject.subject.should == fact_subject
        end
      end
    end

    describe "the collection" do

      let(:fact_1) { Factories::Fact.fact_1 }
      let(:fact_2) { Factories::Fact.fact_2 }

      it "enumerable functions work" do
        subject.to_a.should == []
      end

      it "<< can add a fact" do
        subject << fact_1
        subject.to_a.should == [fact_1]
      end

      it "<< can add two facts" do
        subject << fact_1
        subject << fact_2
        subject.to_a.should == [fact_1, fact_2]
      end
    end
  end
end
