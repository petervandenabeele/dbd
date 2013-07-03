require 'spec_helper'

module TestFactories
  module Fact
    describe ID do

      let(:fixed_id) { described_class.fixed_id }

      it 'fixed_id is exactly this fixed id' do
        fixed_id.should == '825e44d5-af33-4858-8047-549bd813daa8'
      end
    end
  end
end
