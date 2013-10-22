require 'dbd/fact/factory'
require 'dbd/fact/collection'
require 'dbd/fact/subject'
require 'dbd/fact/id'

module Dbd

  ##
  # Basic Fact of knowledge.
  #
  # The database is built as an ordered sequence of facts, a "fact stream".
  #
  # This is somewhat similar to a "triple" in the RDF (Resource Description
  # Framework) concept, but with different and extended functionality.
  #
  # Each basic fact has:
  # * a *time_stamp*  (time with nanosecond granularity)
  #
  #   To allow verifying that the order in a fact stream is correct.
  #
  #   A time_stamp does not need to represent the exact time of the
  #   creation of the fact, but it has to increase in strictly monotic
  #   order in a fact stream.
  #
  # * a *id* (unique and invariant)
  #
  #   To allow referencing back to it (e.g. to invalidate it later in a fact stream).
  #   The id is implemented as a uuid. In the CSV serialization the 32+4 character
  #   representation is used.
  #
  # * a *context_subject* (a uuid)
  #
  #   The subject of the Context (a set of ContextFacts with the same subject)
  #   about this fact. Each Fact, points *back* to a Context.
  #
  # * a *subject* (a uuid)
  #
  #   "About which Resource is this fact?"
  #
  #   Similar to the subject of an  RDF triple, except that this subject is not
  #   a URI, but an abstract uuid (that is world-wide unique and invariant).
  #
  #   Links to "real-world" URI's and URL's can be added later as separate facts
  #   (this also allows linking multiple "real-world" URI's to a single Resource).
  #
  # * a *predicate* (a string)
  #
  #   "Which property of the resource are we describing?"
  #
  #   Currently this is a string, but I suggest modeling this similar to predicate
  #   in RDF. Probably more detailed modeling using RDF predicate will follow.
  #
  # * an *object_type* (a short string)
  #
  #   "What is the type of the object?"
  #
  #   A short string that encodes the type of the object. Based loosely on
  #   thrift and RDF (xsd), following types are suggested:
  #
  #   data types:
  #   * s : String (like xsd:string and thrift string)
  #   * b : Boolean (like xsd:boolean and thrift bool)  ("true" or "false")
  #   * d : Decimal (like xsd:decimal ; not present in thrift)
  #   * f : Float (like xsd:double and thrift double)
  #   * l : Long Int (like thrift i64 signed 64 bit integer)
  #   * t : Time (like xsd:dateTime and Ruby Time (date + time combined))
  #
  #   references:
  #   * i : ID (currently a UUID, with its 32+4 char representation)
  #   * r : Resource (currently a UUID, with its 32+4 char representation)
  #   * c : Context (currently a UUID, with its 32+4 char representation)
  #   * u : URI (like RDF URI's)
  #
  #   In this version, only String, Boolean and Resource are implemented.
  #
  # * an *object* (a value, of type object_type)
  #
  #   "What is the value of the property of the resource we are describing?".
  #
  #   Serialized to a string, but can be of any of the object_types.
  class Fact

    ##
    # @return [Module] The module that has the factories for Fact
    def self.factory
      self::Factory
    end

    ##
    # @return [Array] The 7 attributes of a Fact.
    def self.attributes
      [:time_stamp,
       :id,
       :context_subject,
       :subject,
       :predicate,
       :object_type,
       :object]
    end

    attributes.each do |attribute|
      attr_reader attribute
    end

    ##
    # These "set once" setters implement a form of immutable behavior.
    # The value can be set once (after initial creation the object),
    # but can never be changed after that.
    #
    # A set_once setter for time_stamp.
    #
    # The input class is validated (easy confusion with String or Time).
    #
    # @param [TimeStamp] time_stamp a time_stamp (not a Time or a String)
    def time_stamp=(time_stamp)
      validate_time_stamp_class(time_stamp)
      set_once(:time_stamp, time_stamp)
    end

    ##
    # A set_once setter for context_subject.
    #
    # @param [String] context_subject a string representation of the uuid
    def context_subject=(context_subject)
      set_once(:context_subject, context_subject)
    end

    ##
    # A set_once setter for subject.
    #
    # @param [String] subject a string representation of the uuid
    def subject=(subject)
      set_once(:subject, subject)
    end

    ##
    # Builds a new Fact.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [#to_s] :object Required :  the object for this Fact (required)
    # @option options [#to_s] :object_type Required :  the object_type for this Fact (required)
    # @option options [#to_s] :predicate Required : the predicate for this Fact
    # @option options [String (uuid)] :subject Optional : the subject for this Fact
    # @option options [String (uuid)] :context_subject Optional : the subject of the Context
    # @option options [String (uuid)] :id Optional : set the id
    # @option options [TimeStamp] :time_stamp Optional : the time_stamp for this Fact
    def initialize(options)
      @time_stamp = options[:time_stamp]
      @id = options[:id] || self.class.factory.new_id
      @context_subject = options[:context_subject]
      @subject = options[:subject]
      @predicate = options[:predicate]
      @object_type = options[:object_type]
      @object = options[:object]
      validate_time_stamp_class(@time_stamp)
      raise PredicateError, "predicate cannot be nil" if predicate.nil?
      raise ObjectError, "object_type cannot be nil" if object_type.nil?
      raise ObjectError, "object cannot be nil" if object.nil?
    end

    ##
    # @return [Array] The 7 values of a Fact.
    def values
      self.class.attributes.map{ |attribute| self.send(attribute) }
    end

    ##
    # @return [Array] The 7 values of a Fact converted to a string.
    # The individual strings are escaped:
    # * newlines are escaped to '\n'
    # This is used for the 7 entries in the to_CSV mapping.
    #
    def string_values
      values.map{ |value| escaped_string(value.to_s) }
    end

    ##
    # Equivalent facts (have all same values, except time_stamp which is near?).
    #
    # For "equality" only a test on the id is used. If the id
    # (which is a uuid) is the same, we assume that is the "same"
    # fact. This equivalent? method is used to test is equal
    # methods are "really" equivalent.
    #
    # The time_stamp may be slightly different (because shifts
    # of a few nanoseconds will be required to resolve collisions
    # on merge).
    #
    # @param [Fact] other the other fact to compare with
    # @return [trueish]
    def equivalent?(other)
      (self.class.attributes - [:time_stamp]).
        all?{ |attribute| self.send(attribute) == other.send(attribute) } &&
        self.time_stamp.near?(other.time_stamp)
    end

    ##
    # @return [String] a short string representation of a Fact
    def short
      "#{context_subject_short} : " \
      "#{subject.to_s[0...8]} : " \
      "#{predicate.to_s.ljust(24, ' ').truncate_utf8(24)} : " \
      "#{object.to_s.truncate_utf8(80).gsub(/\n/, '_')}"
    end

    ##
    # Checks if a fact has errors for storing in the graph.
    #
    # @return [Array] an Array of error messages
    def errors
      # * id not validated, is set automatically upon creation
      # * time_stamp not validated, is set automatically later
      # * predicate not validated, is validated upon creation
      # * object not validated, is validated upon creation
      [context_subject_error(context_subject),
       subject ? nil : "Subject is missing"].compact
    end

    ##
    # Validates the presence or absence of context_subject.
    #
    # Here, in (base) Fact, context_subject must be present.
    #
    # In the derived ContextFact it must NOT be present.
    # This is how the difference is encoded between Fact and
    # ContextFact in the fact stream.
    #
    # @param [Object] context_subject
    # Return [nil, String] nil or an error message
    def context_subject_error(context_subject)
      "ContextFact subject is missing" unless context_subject
    end

    ##
    # Confirms this is not a ContextFact.
    #
    # Needed for validations that depend on different behavior for
    # a context_fact (mainly, no context_subject).
    #
    # @return [trueish] false in the Fact implementation
    def context_fact?
      false
    end

  private

    def context_subject_short
      "#{context_subject.to_s[0...8]}"
    end

    def validate_time_stamp_class(time_stamp)
      unless time_stamp.nil? || time_stamp.is_a?(TimeStamp)
        raise ArgumentError, "time_stamp is of class #{time_stamp.class}, should be TimeStamp"
      end
    end

    def escaped_string(string)
      string.
        gsub(%r{\\}, "\\\\\\\\"). # single \ => double \\
        gsub(%r{\n}, '\n') # newline => \n
    end

  end
end
