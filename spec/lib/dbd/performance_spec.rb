require 'spec_helper'
require 'benchmark'

module Dbd
  describe "performance" do

    include Benchmark

    # no let because we do not want memoized
    def new_subject
      Fact.new_subject
    end

    let(:provenance_fact_1) { Factories::ProvenanceFact.context(new_subject) }

    NUMBER_OF_FACTS = 10_000

    describe "#{NUMBER_OF_FACTS} facts" do
      it "reports and checks the used time" do
        graph = Graph.new
        graph << provenance_fact_1
        # Rehearsal
        NUMBER_OF_FACTS.times do |counter|
          data_fact = Factories::Fact.data_fact(provenance_fact_1, new_subject)
          graph << data_fact
        end
        # Actual
        start = Time.now
        NUMBER_OF_FACTS.times do |counter|
          data_fact = Factories::Fact.data_fact(provenance_fact_1, new_subject)
          graph << data_fact
        end
        duration = Time.now - start
        puts "\nDuration for inserting #{NUMBER_OF_FACTS} facts in the in-memory graph was #{duration*1000_000/NUMBER_OF_FACTS} us PER FACT"
        graph.size.should == 2 * NUMBER_OF_FACTS + 1
        duration.should < 0.000_15 * NUMBER_OF_FACTS
        # typ. 37 us on Mac Ruby 2.0.0 (on 2013-05-15 over 15K iterations)
        # typ. 45 us on Mac Ruby 2.0.0 (on 2013-06-05 over 10K iterations)
        # typ. 60 us on Mac jruby 1.7.3
      end
    end
  end
end
