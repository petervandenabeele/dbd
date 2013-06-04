require 'spec_helper'

module Dbd
  describe Fact do
    let(:provenance_subject) { ProvenanceFact.new_subject }
    let(:subject) { described_class.new_subject }
    let(:data_predicate)  { "http://example.org/test/name" }
    let(:string_object_1)  { "Gandhi" }
    let(:fact_2_with_subject) { Factories::Fact.fact_2_with_subject(provenance_subject) }

    describe "factory works" do
      it "with explicit provenance_subject" do
        fact_2_with_subject.provenance_subject.should be_a(provenance_subject.class)
        fact_2_with_subject.subject.should be_a(subject.class)
        fact_2_with_subject.predicate.should be_a(data_predicate.class)
        fact_2_with_subject.object.should be_a(string_object_1.class)
      end

      it "without explicit provenance_subject" do
        Factories::Fact.fact_1.provenance_subject.should be_nil
      end

      it "fact_2_with_subject should not raise_error" do
        Factories::Fact.fact_2_with_subject
      end

      it "fact_3_with_subject should not raise_error" do
        Factories::Fact.fact_3_with_subject
      end

      describe "data_fact" do
        describe "without arguments" do
          it "has empty provenance_subject" do
            Factories::Fact.data_fact.provenance_subject.should be_nil
          end

          it "has empty subject" do
            Factories::Fact.data_fact.subject.should be_nil
          end
        end

        describe "with provenance_subject" do
          it "has provenance_subject" do
            Factories::Fact.data_fact(provenance_subject).
              provenance_subject.should == provenance_subject
          end

          it "has empty subject" do
            Factories::Fact.data_fact(provenance_subject).subject.should be_nil
          end
        end

        describe "with provenance_subject and subject" do
          it "has provenance_subject" do
            Factories::Fact.data_fact(provenance_subject, subject).
              provenance_subject.should == provenance_subject
          end

          it "has subject" do
            Factories::Fact.data_fact(provenance_subject, subject).
              subject.should == subject
          end
        end
      end
    end
  end
end
