module Dbd

  ##
  # ResourcesWithProvenance is a set of resources that are all
  # associated with one provenance_resource.
  #
  # The steps are:
  # * make a provenance_resource (Resource.new) and add provenance
  #   facts to that. Take the provenance_subject from it.
  # * make 1 or more resources for regular facts (Resource.new)
  #   (carry over the provenance_subject) and add facts to that.
  # * make ResourcesWithProvenance.new(provenance_resource) and
  #   add the resources to it.
  # * call the Graph#store method with resources_with_provenance
  class ResourcesWithProvenance

    include Helpers::OrderedSetCollection

    attr_reader :provenance_resource

    class InvalidProvenanceError < StandardError ; end

    ##
    # Initialize the ResourcesWithProvenance with a provenance resource.
    #
    # @param [Resource] provenance_resource the provenance resource for the facts
    def initialize(provenance_resource)
      super()
      @provenance_resource = provenance_resource
    end

    ##
    # Validate that the provenance added resource
    # is equal to the subject of the provenance_resource
    #
    # @param [Resource] resource a resource that is added to the instance
    def <<(resource)
      raise InvalidProvenanceError if resource.provenance_subject != provenance_resource.subject
      super
    end

  end
end
