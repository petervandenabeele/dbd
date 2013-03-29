require 'spec_helper'

module Dbd
  module Facts
    describe Base do
      it "module exists" do
        described_class # should not raise error
      end

      it "The RDF module is loaded" do
        RDF # should not raise error
      end
    end
  end
end
