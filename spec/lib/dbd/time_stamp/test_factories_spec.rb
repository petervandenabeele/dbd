require 'spec_helper'

module TestFactories
  describe TimeStamp do

    let(:fixed_time_stamp) { described_class.fixed_time_stamp }

    describe 'factory works' do
      it 'is a TimeStamp' do
        fixed_time_stamp.should be_a(described_class.factory_for)
      end

      it 'has an exact time' do
        fixed_time_stamp.to_s.should == '2013-06-17 21:55:09.967653013 UTC'
      end
    end
  end
end
