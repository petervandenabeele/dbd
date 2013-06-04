require 'spec_helper'

module Dbd
  describe ProvenanceFact do

    describe "Factories do not fail" do
      it "Factories::ProvenanceFact.context is OK" do
        Factories::ProvenanceFact.context.should_not be_nil
      end

      it "Factories::ProvenanceFact.created_by is OK" do
        Factories::ProvenanceFact.created_by.should_not be_nil
      end

      it "Factories::ProvenanceFact.original_source is OK" do
        Factories::ProvenanceFact.original_source.should_not be_nil
      end

      it "Factories::ProvenanceFact.new_subject is OK" do
        Factories::ProvenanceFact.new_subject.should be_a(ProvenanceFact.new_subject.class)
      end
    end
  end
end
