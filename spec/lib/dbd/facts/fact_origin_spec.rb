require 'spec_helper'

module Dbd
  module Facts
    describe FactOrigin do
      describe "#new" do

        let(:fact_origin_1) do
          described_class.new()
        end

        let(:fact_origin_2) do
          described_class.new()
        end

        let(:fact_origin_full_option) do
          described_class.new(
            context: "public",
            original_source: "http://example.org/foo",
            created_by: "peter_v",
            entered_by: "peter_v",
            created_at: Time.now.utc,
            entered_at: Time.now.utc,
            valid_from: Time.utc(2000,"jan",1,0,0,0),
            valid_until: Time.utc(2200,"jan",1,0,0,0))
        end

        it "has a unique id (UUID)" do
          fact_origin_1.id.should be_a(Helpers::TempUUID)
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
    end
  end
end
