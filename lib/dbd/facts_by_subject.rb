require 'dbd/helpers/ordered_set_collection'

module Dbd
  ##
  # A collection of facts that have the same subject.
  #
  # This will probably be renamed to Resource.
  class FactsBySubject

    attr_reader :subject

    include Helpers::OrderedSetCollection

    def initialize(subject = nil)
      super()
      @subject = subject
    end

  end
end
