require 'dbd/resources_with_provenance/collection'

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
  #   add the resources to that
  # * call resources_with_provenance.generate_subjects to
  #   generate the missing subjects and interlink
  # * call the Graph#store method with resources_with_provenance
  class ResourcesWithProvenance

    attr_reader :provenance_resource
    attr_reader :resource_collection

    ##
    # Initialize the ResourcesWithProvenance with a provenance resource.
    #
    # @param [Resource] provenance_resource the provenance resource for the facts
    def initialize(provenance_resource)
      @provenance_resource = provenance_resource
      @resource_collection = Collection.new
    end

  end
end
