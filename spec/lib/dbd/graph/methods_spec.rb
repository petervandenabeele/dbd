require 'spec_helper'

module Dbd
  describe Graph do
    let(:full_graph) { TestFactories::Graph.full }

    context 'resources' do
      it 'is an array' do
        full_graph.resources.should be_a(Array)
      end

      it 'is an array of resources' do
        full_graph.resources.each do |resource|
          resource.should be_a(Resource)
        end
      end

      it 'the resources has the facts' do
        facts = full_graph.reject(&:context_fact?)
        full_graph.resources.single.should include(*facts)
      end

      it 'the resources does not have context_facts' do
        context_facts = full_graph.select(&:context_fact?)
        full_graph.resources.single.should_not include(*context_facts)
      end

      it 'has at least one entry' do
        full_graph.resources.should_not be_empty
      end
    end

    context 'contexts' do
      it 'is an array' do
        full_graph.contexts.should be_a(Array)
      end

      it 'is an array of contexts' do
        full_graph.contexts.each do |context|
          context.should be_a(Context)
        end
      end

      it 'the contexts has the context_facts' do
        context_facts = full_graph.select(&:context_fact?)
        full_graph.contexts.single.should include(*context_facts)
      end

      it 'the contexts does not have facts' do
        facts = full_graph.reject(&:context_fact?)
        full_graph.contexts.single.should_not include(*facts)
      end

      it 'has at least one entry' do
        full_graph.contexts.should_not be_empty
      end
    end
  end
end
