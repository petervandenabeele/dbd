require 'spec_helper'

module Dbd
  describe "performance" do

    def new_subject
      Fact.new_subject
    end

    let(:provenance_fact_1) { Factories::ProvenanceFact.context(new_subject) }

    NUMBER_OF_FACTS = 1000

    describe "1000 facts" do
      it "reports and checks the used time" do
        graph = Graph.new
        graph << provenance_fact_1
        start = Time.now
        NUMBER_OF_FACTS.times do |counter|
          data_fact = Factories::Fact.data_fact(provenance_fact_1, new_subject)
          graph << data_fact
        end
        duration = Time.now - start
        puts "\nDuration for inserting #{NUMBER_OF_FACTS} facts in the in-memory graph was #{duration*1000} ms"
        graph.size.should == NUMBER_OF_FACTS + 1
        duration.should <
          # dramatic performance difference, not immediately found what is the cause
          # creating new data_fact objects consumes 330 ms of the typ. 400 ms on JRuby
          case RUBY_ENGINE
          when "ruby"
            0.100 # 100 ms (typ. 30 ms on Mac Ruby 2.0.0)
          when "jruby"
            1.000 # 1000 ms (typ. 400 ms on Mac jruby 1.7.3)
          end
      end
    end
  end
end
