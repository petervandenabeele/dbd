require 'spec_helper'

module Dbd
  describe Context do

    let(:context) { described_class.new }
    let(:context_subject) { context.subject }

    describe 'TestFactories::Context' do
      it '.context works' do
        TestFactories::Context.context
      end
    end
  end
end
