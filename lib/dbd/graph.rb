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
    # Allow max 1 ms offset of time_stamps precursing actual time
    # reported by Wall clock (because of 1 ms granularity of JRuby,
    # that should be enough). The problem is that the newest_time_stamp
    # starts to precurse a few ns, compared to reported Wall clock
    # on JRuby, and this falsely triggers the OutOfOrderError below.
    MAX_OFFSET = Rational('1/1000') # 1 ms

    ##
    # Offset given to reported Wall clock to enforce the
    # monotonic increasing order.
    TIME_OFFSET = Rational('2/1000_000_000') # 2 ns

    ##
    # Setting a strictly monotonically increasing time_stamp (if not yet set).
    #
    # Sometimes an offset needs to be given, since on Java (JRuby) the Wall
    # time has a resolution of only 1 ms so sometimes, the exact same value
    # for Time.now (with ms granularity) is reported when passing here.
    def enforce_strictly_monotonic_time(fact)
      return if fact.time_stamp
      new_time = Time.now.utc
      newest_time_stamp = newest_time_stamp()
      if newest_time_stamp && new_time < (newest_time_stamp - MAX_OFFSET)
        raise OutOfOrderError, "newest_time_stamp.nsec = #{newest_time_stamp.nsec} :: new_time.nsec = #{new_time.nsec}"
      end
      if newest_time_stamp && new_time <= newest_time_stamp
        new_time = newest_time_stamp + TIME_OFFSET
      end
      fact.time_stamp = new_time
    end

  end
end
