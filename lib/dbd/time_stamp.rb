module Dbd

  ##
  # TimeStamp
  #
  # Each Fact has a time_stamp with a granularity of 1 ns. The small
  # granularity is essential to allow enough "density" of Facts in a
  # large fact stream. Since all Facts need to have a strictly
  # monotonically increasing time_stamp, this causes a limitation of
  # max 1_000_000_000 Facts per second in a fact stream.
  #
  # A second reason for a fine grained granularity of the time_stamp
  # is to reduce the chance (but not to zero) for collisions between
  # Facts when 2 (or more) fact streams with overlapping time ranges
  # need to be merged. But, collisions are always possible and need
  # to be handled (since this can be expensive, we need to avoid them).
  #
  # A practicaly problem with calculating a "randomized" time_stamp is
  # that the system reports a Wall clock with a granularity of 1 us on
  # MRI Ruby and only 1 ms on JRuby (see JSR 310). To solve this problem,
  # some nifty tricks are needed to create more "randomized" time_stamps,
  # while still guaranteeing, the strictly monotonic increase in an
  # upredictable fact stream.
  #
  # Performance measurements show a typical 30 - 60 us delay between the
  # consecutive created facts (on MRI and JRuby), so a randomization of
  # e.g. 1 - 999 ns should not cause fundamental problems for the density
  # of the facts (even if computers speed up a factor of 30 or an
  # implementation in a faster language). Still this is an ad-hoc
  # optimization at creation time and can be optimized without breaking
  # the specification of the fact stream.
  #
  # A time_stamp does not need to represent the exact time of the
  # creation of the fact, it only has to increase strictly monotic
  # in a fact stream.
  class TimeStamp

    include DefineEquality(:time)
    attr_reader :time

    ##
    # Builds a new TimeStamp.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Time, String] :time (Time.now) force the time to this value
    # @option options [TimeStamp] :larger_than (void) time_stamp must be larger than this
    def initialize(options={})
      @time = options[:time] || new_time(options[:larger_than])
      @time = time_from_s(@time) if @time.is_a?(String)
    end

    ##
    # regexp for the nanosecond granularity and in UTC
    #
    # Can be used to validate input strings or in tests.
    def self.to_s_regexp
      /\A\d{4}-\d\d-\d\d \d\d:\d\d:\d\d\.\d{9} UTC\Z/
    end

    class << self
      alias_method :valid_regexp, :to_s_regexp
    end

  private

    def new_time(larger_than)
      [Time.now.utc, (larger_than && larger_than.time)].compact.max + random_offset
    end

    def random_offset
      Rational("#{1+rand(999)}/1_000_000_000")
    end

    def time_format
      '%F %T.%N %Z'
    end

    ##
    # with a nanosecond granularity and in UTC
    def time_from_s(time_string)
      # For ns precision in JRuby this extended process is required
      time_hash = DateTime._strptime(time_string, time_format)
      validate_time_zone(time_hash)
      Time.utc(time_hash[:year],
               time_hash[:mon],
               time_hash[:mday],
               time_hash[:hour],
               time_hash[:min],
               time_hash[:sec],
               time_hash[:sec_fraction] * 1_000_000)
    end

    def validate_time_zone(time_hash)
      unless time_hash[:zone] == 'UTC'
        raise(ArgumentError, "Time zone was #{time_hash[:zone]}, must be 'UTC'")
      end
    end

  public

    ##
    # with a nanosecond granularity and in UTC
    def to_s
      @time.strftime(time_format)
    end

    # Max drift in time_stamp
    MAX_DRIFT = Rational("1/1_000_000")

    ##
    # determines if 2 time_stamps are "near".
    #
    # The time_stamp of an equivalent fact may be slightly different
    # (because shifts of a few nanoseconds will be required to resolve
    # collisions on a merge of fact streams with overlapping time_stamp
    # ranges).
    def near?(other)
      (self - other).abs <= MAX_DRIFT
    end

    def >(other)
      @time > other.time
    end

    def <(other)
      @time < other.time
    end

    def >=(other)
      @time >= other.time
    end

    def <=(other)
      @time <= other.time
    end

    def +(seconds)
      self.class.new(time: (@time + seconds))
    end

    def -(other)
      @time - other.time
    end

  end
end
