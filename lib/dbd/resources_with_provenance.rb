module Dbd

  ##
  # ResourcesWithProvenance is a set of resources that are all
  # associated with one provenance_resource.
  #
  # The steps are:
  # * make a provenance_resource (Resource.new) and add provenance
  #   facts to that
  # * make 1 or more resources for regular facts (Resource.new)
  #   and add facts to that, grouped per resource
  # * make ResourcesWithProvenance.new(provenance_resource) and
  #   add the resources to it. Upon adding the resources, the
  #   provenance is set on the resource.
  # * call the Graph#store method with resources_with_provenance
  class ResourcesWithProvenance

    include Helpers::OrderedSetCollection

    attr_reader :provenance_resource

    ##
    # Initialize the ResourcesWithProvenance with a provenance resource.
    #
    # @param [Resource] provenance_resource the provenance resource for the facts
    def initialize(provenance_resource)
      super()
      @provenance_resource = provenance_resource
    end

  end
end
