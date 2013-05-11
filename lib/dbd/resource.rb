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

    include Helpers::OrderedSetCollection

    attr_reader :subject

    ##
    # Build a new resource.
    #
    # The subject argument is required (because later
    # additions of elements take over this subject).
    def initialize(subject)
      raise InvalidSubjectError if subject.nil?
      super()
      @subject = subject
    end

    ##
    # Add an element.
    #
    # * if it has no subject, the subject is set in a duplicate element
    # * if is has the same subject as the resource, added unchanged.
    # * if it has a different subject, a InvalidSubjectError is raised.
    def <<(element)
      super(check_or_set_subject(element))
    end

  private

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

  end
end
