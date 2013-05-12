require 'dbd/helpers/ordered_set_collection'

module Dbd
  ##
  # A Resource is a collection of facts that have the same subject.
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
  # can be nil. These will then be set in a local duplicate when the
  # Fact is added (with '<<') to a resource.
  class Resource

    include Helpers::OrderedSetCollection

    attr_reader :subject

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
    # Add an element.
    #
    # * if it has no subject, the subject is set in a duplicate element
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a SubjectError is raised.
    # * if it has no provenance_subject, the provenance_subject is set in a duplicate element
    # * if is has the same provenance_subject as the resource, added unchanged.
    # * if it has a different provenance_subject, a ProvenanceError is raised.
    def <<(element)
      super(check_or_set_subject_and_provenance(element))
    end

    ##
    # Getter for provenance_subject.
    #
    # Will be overridden in the ProvenanceResource subclass.
    def provenance_subject
      @provenance_subject
    end

  private

    def check_or_set_subject_and_provenance(element)
      with_subject = check_or_set_subject(element)
      check_or_set_provenance(with_subject)
    end

    def check_or_set_subject(element)
      if element.subject
        if element.subject == @subject
          return element
        else
          raise SubjectError,
            "self.subject is #{subject} and element.subject is #{element.subject}"
        end
      else
        element.dup_with_subject(@subject)
      end
    end

    # this will be overriden in the ProvenanceResource sub_class
    def check_or_set_provenance(element)
      if element.provenance_subject
        if element.provenance_subject == @provenance_subject
          return element
        else
          raise ProvenanceError,
            "self.provenance_subject is #{provenance_subject} and element.provenance_subject is #{element.provenance_subject}"
        end
      else
        element.dup_with_provenance_subject(@provenance_subject)
      end
    end

    def validate_provenance_subject
      raise ProvenanceError if @provenance_subject.nil?
    end

  end
end
