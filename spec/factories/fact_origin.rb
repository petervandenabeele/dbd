module Factories
  module FactOrigin
    def self.me
      ::Dbd::FactOrigin::FactOrigin.new(
        context: "public",
        original_source: "http://example.org/foo",
        created_by: "peter_v",
        entered_by: "peter_v",
        created_at: Time.now.utc,
        entered_at: Time.now.utc,
        valid_from: Time.utc(2000,"jan",1,0,0,0),
        valid_until: Time.utc(2200,"jan",1,0,0,0))
    end
  end
end
