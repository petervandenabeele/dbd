require 'dbd/helpers/ordered_set_collection'

module Dbd
  ##
  # A Resource is a collection of Facts that have the same subject.
  #
  # In the real-world this is a mainly an "instance" about which all
  # facts are giving information (e.g. a conference, a person, a
  # bicycle, ...). More generally this can also be used to describe
  # classes and other concepts in the software system.
  #
  # A new (random) subject is generated for a resource. In Dbd,
  # a subject is a random uuid (like a oid), not a meaningful URI
  # as it is in RDF.
  #
  # A provenance_subject is a required field in the options hash.
  # Practically, first a ProvenanceResource will be created and the
  # subject of that will be used as provenance_subject for the
  # Resources that are associated with it.
  #
  # During build-up of a Fact, the subject and the provenance_subject
  # can be nil. These will then be set when the Fact is added
  # (with '<<') to a resource.
  class Resource

    include Helpers::OrderedSetCollection

    attr_reader :subject

    ##
    # Getter for provenance_subject.
    #
    # Will be overridden in the ProvenanceResource subclass.
    def provenance_subject
      @provenance_subject
    end

    ##
    # @return [Fact::Subject] a new (random) Resource subject
    def self.new_subject
      Fact.new_subject
    end

    ##
    # Build a new resource.
    #
    # By default, a new (random) subject is generated for a resource.
    # Optionally, an explicit subject can be given in the options parameter
    # (this is best created with the new_subject class method for forward
    # compatibility).
    #
    # The provenance_subject argument is required. This will typically be
    # taken from an earlier created ProvenanceResource.
    #
    # @param [Hash{Symbol => Object}] options
    # @option options [Fact::Subject] :provenance_subject (required) the subject of the provenance resource for this resource
    # @option options [Fact::Subject] :subject (new_subject) Optional: the subject for the resource
    def initialize(options)
      @subject = options[:subject] || self.class.new_subject
      @provenance_subject = options[:provenance_subject]
      validate_provenance_subject
      super()
    end

    ##
    # Add a Fact (strictly not a ProvenanceFact)
    #
    # Side effects on subject and provenance_subject:
    # * if it has no subject, the subject is set (this modifies the fact !)
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    # * if it has no provenance_subject, the provenance_subject is set (this modifies the fact !)
    # * if is has the same provenance_subject as the resource, added unchanged.
    # * if it has a different provenance_subject, a ProvenanceError is raised.
    def <<(fact)
      assert_provenance_fact(fact)
      set_subject!(fact)
      set_provenance!(fact)
      super(fact)
    end

  private

    def set_subject!(fact)
      fact.subject = subject
    end

    # Will be overriden in the ProvenanceResource sub_class.
    def set_provenance!(fact)
      fact.provenance_subject = provenance_subject
    end

    # Will be overriden in the ProvenanceResource sub_class.
    def validate_provenance_subject
      raise ProvenanceError if @provenance_subject.nil?
    end

    # Assert _no_ ProvenanceFacts here
    def assert_provenance_fact(fact)
      raise ArgumentError, "Trying to add a ProvenanceFact to a Resource." if fact.provenance_fact?
    end

  end
end
