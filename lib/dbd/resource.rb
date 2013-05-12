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
  # The subject is required from the creation of a new resource.
  #
  # During build-up of a Fact, the subject can be nil. This will then
  # be set in a local duplicate when the Fact is added to a resource
  # (a subject in Dbd is a random uuid (like a oid), not a meaningful URI).
  class Resource

    class InvalidSubjectError < StandardError ; end
    class InvalidProvenanceError < StandardError ; end

    include Helpers::OrderedSetCollection

    attr_reader :subject

    ##
    # Build a new resource.
    #
    # The subject argument is required (because later
    # additions of elements take over this subject).
    #
    # The provenance_subject argument is required
    # because additions of elements take over this
    # subject)
    # @param [Subject] subject the subject for the resource
    # @param [Subject] provenance_subject the subject of the provenance resource for this resource
    def initialize(subject, provenance_subject)
      super()
      @subject = subject
      @provenance_subject = provenance_subject
      raise InvalidSubjectError if subject.nil?
      validate_provenance_subject
    end

    ##
    # Add an element.
    #
    # * if it has no subject, the subject is set in a duplicate element
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a InvalidSubjectError is raised.
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
          raise InvalidSubjectError,
            "self.subject is #{subject} and element.subject is #{element.subject}"
        end
      else
        element.dup_with_subject(@subject)
      end
    end

    def check_or_set_provenance(element)
      if element.provenance_subject
        if element.provenance_subject == @provenance_subject
          return element
        else
          raise InvalidProvenanceError,
            "self.provenance_subject is #{provenance_subject} and element.provenance_subject is #{element.provenance_subject}"
        end
      else
        element.dup_with_provenance_subject(@provenance_subject)
      end
    end

    def validate_provenance_subject
      raise InvalidProvenanceError if @provenance_subject.nil?
    end

  end
end
