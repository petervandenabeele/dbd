require 'spec_helper'

module Dbd
  module Helpers
    describe OrderedSetCollection do

      let(:element_1) {:element_1}
      let(:element_2) {:element_2}
      let(:subject) do
        o = Object.new
        o.extend(described_class)
        o.send(:initialize)
        o
      end

      describe 'create an elements collection' do
        it 'the collection is not an array' do
          # do not derive from Ruby standard classes
          subject.should_not be_a(Array)
        end
      end

      describe 'accessor functions' do
        it 'the collection has Enumerable methods' do
          subject.map #should_not raise_exception
          subject.first #should_not raise_exception
        end

        it '<< adds the element' do
          subject << element_1
          subject.count.should == 1
        end

        it 'returns self to allow chaining' do
          (subject << element_1).should == subject
        end

        it 'other functions (e.g. pop) do not work' do
          lambda {subject.pop} . should raise_exception NoMethodError
        end

        describe 'add_and_return_index returns the index of the inserted element' do

          let(:internal_collection) do
            subject.instance_variable_get('@internal_collection')
          end

          let(:index) do
            described_class.add_and_return_index(element_1, internal_collection)
          end

          before(:each) { index }

          it 'works for 1 element' do
            index.should == 0
          end

          it 'works for 2 elements' do
            index_2 = described_class.add_and_return_index(element_2, internal_collection)
            index_2.should == 1
          end
        end

        describe 'last' do
          it 'returns the last element' do
            subject << element_1
            subject << element_2
            subject.last.should == element_2
          end
        end

        describe 'size' do
          it 'returns the last element' do
            subject << element_1
            subject << element_2
            subject.size.should == 2
          end
        end
      end

      describe 'on empty collection' do
        it '#last returns nil' do
          subject.last.should be_nil
        end
      end
    end
  end
end
