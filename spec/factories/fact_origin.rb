module Factories
  module FactOrigin
    def self.me
      ::Dbd::FactOrigin::Base.new(
        context: "public",
        original_source: "http://example.org/foo",
        created_by: "peter_v",
        entered_by: "peter_v",
        created_at: Time.now.utc,
        entered_at: Time.now.utc,
        valid_from: Time.utc(2000,"jan",1,0,0,0),
        valid_until: Time.utc(2200,"jan",1,0,0,0))
    end

    def self.tijd
      ::Dbd::FactOrigin::Base.new(
        context: "public",
        original_source: "http://tijd.be/article#13946",
        created_by: "peter_v",
        entered_by: "peter_v",
        created_at: Time.utc(2013,"apr",1,0,0,0),
        entered_at: Time.now.utc,
        valid_from: Time.utc(2000,"jan",1,0,0,0),
        valid_until: Time.utc(2200,"jan",1,0,0,0))
    end

    def self.special
      ::Dbd::FactOrigin::Base.new(
        context: "public",
        original_source: "this has a comma , a newline \n and a double quote \"",
        created_by: "peter_v",
        entered_by: "peter_v",
        created_at: Time.utc(2013,"apr",1,0,0,0),
        entered_at: Time.now.utc,
        valid_from: Time.utc(2000,"jan",1,0,0,0),
        valid_until: Time.utc(2200,"jan",1,0,0,0))
    end

    module Collection
      def self.me_tijd
        ::Dbd::FactOrigin::Collection.new.tap do |fact_origins|
          fact_origins << FactOrigin.me
          fact_origins << FactOrigin.tijd
        end
      end

      def self.special
        ::Dbd::FactOrigin::Collection.new.tap do |fact_origins|
          fact_origins << FactOrigin.special
        end
      end
    end
  end
end
