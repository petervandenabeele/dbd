require 'spec_helper'

module Dbd
  module FactOrigin
    describe FactOrigin do
      describe "#new" do

        let(:fact_origin_1) do
          described_class.new()
        end

        let(:fact_origin_2) do
          described_class.new()
        end

        let(:fact_origin_full_option) do
          Factories::FactOrigin.me
        end

        it "has a unique id (UUID)" do
          fact_origin_1.id.should be_a(UUIDTools::UUID)
        end

        it "two fact_origins have different id" do
          fact_origin_1.id.should_not == fact_origin_2.id
        end

        it "has a context" do
          fact_origin_full_option.context.should be_a(String)
        end

        it "has an original_source" do
          fact_origin_full_option.original_source.should be_a(String)
        end

        it "has a created_by" do
          fact_origin_full_option.created_by.should be_a(String)
        end

        it "has an entered_by " do
          fact_origin_full_option.entered_by.should be_a(String)
        end

        it "has a created_at" do
          fact_origin_full_option.created_at.should be_a(Time)
        end

        it "has an entered_at " do
          fact_origin_full_option.entered_at.should be_a(Time)
        end

        it "has a valid_from" do
          fact_origin_full_option.valid_from.should be_a(Time)
        end

        it "has a valid_until" do
          fact_origin_full_option.valid_until.should be_a(Time)
        end
      end

      describe "Factories do not fail" do
        it "Factories::FactOrigin.me is OK" do
          Factories::FactOrigin.me.should_not be_nil
        end

        it "Factories::FactOrigin.tijd is OK" do
          Factories::FactOrigin.tijd.should_not be_nil
        end
      end
    end
  end
end
