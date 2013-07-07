module Dbd
  class Fact
    module Factory

      class << self

        def top_class
          Fact
        end

        ##
        # Constructs a Fact or ProvenanceFact from a string values array
        # (e.g. pulled from a CSV row).
        #
        # @param [Array] string_values Required : the array with values, organized as in attributes
        # @return [Fact, ProvenanceFact] the constructed fact
        def from_string_values(string_values, options={})
          string_hash = string_hash_from_values(string_values)
          validate_string_hash(string_hash) if options[:validate]
          fact_from_values_hash(values_hash(string_hash))
        end

        def attribute_formats
          # TODO clean this up
          {
            id: [true, Fact::ID.valid_regexp],
            time_stamp: [true, TimeStamp.valid_regexp],
            provenance_subject: [false, Fact::Subject.valid_regexp],
            subject: [true, Fact::Subject.valid_regexp],
            predicate: [true, /./],
            object: [true, /./]
          }
        end

      private

        def string_hash_from_values(string_values)
          attributes_strings_array = [top_class.attributes, string_values].transpose
          # Remove empty values (e.g. the provenance_subject for a ProvenanceFact).
          attributes_strings_array.delete_if{|a,v| v.nil? || v == ''}
          Hash[attributes_strings_array]
        end

        def values_hash(string_hash)
          string_hash.tap do |h|
            h[:time_stamp] = TimeStamp.new(time: h[:time_stamp])
          end
        end

        def fact_from_values_hash(values_hash)
          if values_hash[:provenance_subject]
            Fact.new(values_hash)
          else
            ProvenanceFact.new(values_hash)
          end
        end

        def validate_string_hash(string_hash)
          attribute_formats.each do |attr, validation|
            string = string_hash[attr]
            mandatory, format = validation
            validate_string(mandatory, string, format)
          end
        end

        def validate_string(mandatory, string, format)
          if (mandatory || string) && (string !~ format)
            raise FactError, "invalid entry found : #{string}"
          end
        end

      end

    end
  end
end
