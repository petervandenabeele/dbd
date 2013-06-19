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
  # * a unique and invariant *id* (a uuid)
  #
  #   To allow referencing back to it (e.g. to invalidate it later in a fact stream).
  #
  # * a *time_stamp*  (time with nanosecond granularity)
  #
  #   To allow verifying that the order in a fact stream is correct.
  #
  #   A time_stamp does not need to represent the exact time of the
  #   creation of the fact, but it has to increase in strictly monotic
  #   order in a fact stream.
  #
  # * a *provenance_subject* (a uuid)
  #
  #   The subject of the ProvenanceResource (a set of ProvenanceFacts with
  #   the same subject) about this fact. Each Fact, points *back* to a
  #   ProvenanceResource (the ProvenanceResource must have been fully
  #   defined, earlier in a fact stream).
  #
  # * a *subject* (a uuid)
  #
  #   "About which Resource is this fact?".
  #
  #   Similar to the subject of an  RDF triple, except that this subject is not
  #   a URI, but an abstract uuid (that is world-wide unique and invariant).
  #
  #   Links to "real-world" URI's and URL's can be added later as separate facts
  #   (this also allows linking multiple "real-world" URI's to a single Resource).
  #
  # * a *predicate* (a string)
  #
  #   "Which property of the resource are we describing?".
  #
  #   Currently this is a string, but I suggest modeling this similar to predicate
  #   in RDF. Probably more detailed modeling using RDF predicate will follow.
  #
  # * an *object* (a string)
  #
  #   "What is the value of the property of the resource we are describing?".
  #
  #   Currently this is a string, but I suggest modeling this similar to object
  #   in RDF. Probably more detailed modeling using RDF object will follow.
  class Fact

    ##
    # @return [Array] The 6 attributes of a Fact.
    def self.attributes
      [:id,
       :time_stamp,
       :provenance_subject,
       :subject,
       :predicate,
       :object]
    end

    attributes.each do |attribute|
      attr_reader attribute
    end

    ##
    # A set_once setter for time_stamp.
    #
    # This implements a "form" of immutable behavior. The value can
    # be set once (possibly after creation the object), but can
    # never be changed after that.
    def time_stamp=(time_stamp)
      raise ArgumentError unless time_stamp.is_a?(TimeStamp)
      set_once(:time_stamp, time_stamp)
    end

    ##
    # A set_once setter for subject.
    #
    # This implements a "form" of immutable behavior. The value can
    # be set once (possibly after creation the object), but can
    # never be changed after that.
    def subject=(subject)
      set_once(:subject, subject)
    end

    ##
    # A set_once setter for provenance_subject.
    #
    # This implements a "form" of immutable behavior. The value can
    # be set once (possibly after creation the object), but can
    # never be changed after that.
    def provenance_subject=(provenance_subject)
      set_once(:provenance_subject, provenance_subject)
    end

    ##
    # @return [Subject] A new random subject.
    def self.new_subject
      Subject.new
    end

    ##
    # @return [ID] A new random id.
    def self.new_id
      ID.new
    end

    ##
    # Builds a new Fact.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [#to_s] :predicate Required : the predicate for this Fact
    # @option options [#to_s] :object Required :  the object for this Fact (required)
    # @option options [Subject] :provenance_subject (nil) Optional: the subject of the provenance(resource|fact)
    # @option options [Subject] :subject (nil) Optional: the subject for this Fact
    # @option options [TimeStamp] :time_stamp (nil) Optional: the time_stamp for this Fact
    # @option options [ID] :id Optional : set the id
    def initialize(options)
      @id = options[:id] || self.class.new_id
      @time_stamp = options[:time_stamp]
      @provenance_subject = options[:provenance_subject]
      @subject = options[:subject]
      @predicate = options[:predicate]
      @object = options[:object]
      raise PredicateError, "predicate cannot be nil" if predicate.nil?
      raise ObjectError, "object cannot be nil" if object.nil?
    end

    ##
    # @return [Array] The 6 values of a Fact.
    def values
      self.class.attributes.map{ |attribute| self.send(attribute) }
    end

    ##
    # Constructs a Fact or ProvenanceFact from a values array
    # (e.g. pulled from a CSV row).
    #
    # @param [Array] values Required : the array with values, organized as in attributes
    # @return [Fact, ProvenanceFact] the constructed fact
    def self.from_values(values)
      hash = hash_from_values(values)
      fact_from_hash(hash)
    end

    ##
    # @return [String] a short string representation of a Fact
    def short
      "#{provenance_subject_short} : " \
      "#{subject.to_s[0...8]} : " \
      "#{predicate.to_s.ljust(24, ' ')[0...24]} : " \
      "#{object.to_s[0..60].gsub(/\n/, '_')}"
    end

    ##
    # Executes the required update in used_provenance_subjects.
    #
    # For a Fact, pointing to a ProvenanceResource in it's provenance_subject,
    # marks this provenance_subject in the "used_provenance_subjects" hash that
    # is passed in as an argument (DCI). This will avoid further changes to the
    # ProvenanceResource with this provenance_subject.
    #
    # This is overridden in the ProvenanceFact, since only relevant for a Fact.
    def update_used_provenance_subjects(h)
      # using a provenance_subject sets the key
      h[provenance_subject] = true
    end

    ##
    # Checks if a fact has errors for storing in the graph.
    #
    # @return [Array] an Array of error messages
    def errors
      # * id not validated, is set automatically upon creation
      # * time_stamp not validated, is set automatically later
      # * predicate not validated, is validated in initialize
      # * object not validated, is validated in initialize
      [].tap do |a|
        a << provenance_subject_error(provenance_subject)
        a << "Subject is missing" unless subject
      end.compact
    end

    ##
    # Validates the presence or absence of provenance_subject.
    #
    # Here, in (base) Fact, provenance_subject must be present
    # In the derived ProvenanceFact it must not be present.
    # This is how the difference is encoded between Fact and
    # ProvenanceFact in the fact stream.
    # @param [#nil?] provenance_subject
    # Return [nil, String] nil or an error message
    def provenance_subject_error(provenance_subject)
      "Provenance subject is missing" unless provenance_subject
    end

    ##
    # Confirms this is not a ProvenanceFact.
    #
    # Needed for validations that depend on different behavior for
    # a provenance_fact (mainly, no provenance_subject).
    def provenance_fact?
      false
    end

  private

    def provenance_subject_short
      "#{provenance_subject.to_s[0...8]}"
    end

    def self.hash_from_values(values)
      # Do not keep "empty" values (e.g. the provenance_subject for a ProvenanceFact).
      attributes_values_array = [attributes, values].transpose.select{|a,v| v != ''}
      Hash[attributes_values_array]
    end

    def self.fact_from_hash(hash)
      if hash[:provenance_subject]
        new(hash)
      else
        ProvenanceFact.new(hash)
      end
    end

  end
end
