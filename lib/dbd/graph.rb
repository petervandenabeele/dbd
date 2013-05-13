require 'csv'

module Dbd

  ##
  # The Graph stores the Facts and ProvenanceFacts in an in-memory
  # collection structure.
  class Graph

    include Fact::Collection

    def <<(fact)
      enforce_strictly_monotonic_time(fact)
      super(fact)
    end

    ##
    # Export the graph to a CSV string
    #
    # @return [String] comma separated string with double quoted cells
    def to_CSV
      CSV.generate(force_quotes: true) do |csv|
        @internal_collection.each do |fact|
          csv << fact.values
        end
      end.encode("utf-8")
    end

  private

    ##
    # The system mmust enforce that the time_stamps are strictly monotonic.
    #
    # This has been detected because on Java (JRuby) the the Wall time has
    # a resolution of only 1 ms so sometimes, the exact same value for
    # Time.now was reported.
    def enforce_strictly_monotonic_time(fact)
      return if fact.time_stamp
      new_time = Time.now.utc
      newest_time_stamp = newest_time_stamp()
      raise OutOfOrderError if (newest_time_stamp && new_time < newest_time_stamp)
      if newest_time_stamp && new_time == newest_time_stamp
        new_time = newest_time_stamp + BigDecimal.new("0.000_000_002") # 2 ns
      end
      fact.time_stamp = new_time
    end

  end
end
