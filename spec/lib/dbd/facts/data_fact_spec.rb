require 'spec_helper'

module Dbd
  module Facts
    describe DataFact do

      let(:fact_origin_id) {:fact_origin_id}
      let(:subject_id) {:subject_id}

      let(:data_fact) {described_class.new(fact_origin_id, subject_id)}

      describe "create a data_fact" do
        describe "with a string object type" do
          it "new does not raise exception" do
            data_fact # should_not raise_exception
          end
        end
      end
    end
  end
end
