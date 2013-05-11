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
  # During build-up of the resource, the subject can be nil.
  # This will then be set later by a generate_subjects function
  # (a subject in Dbd is a random uuid's (like a oid), not a
  # meaningful URI).
  class Resource

    attr_reader :subject

    include Helpers::OrderedSetCollection

    def initialize(subject = nil)
      super()
      @subject = subject
    end

  end
end
