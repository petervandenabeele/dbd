require 'dbd/helpers/ordered_set_collection'

module Dbd
  class FactsBySubject

    attr_reader :subject

    include Helpers::OrderedSetCollection

    def initialize(subject = nil)
      super()
      @subject = subject
    end

  end
end
