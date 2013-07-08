require 'spec_helper'

module Dbd
  # TODO move this to dedicated Errors module
  describe "Errors" do
    it "OutOfOrderError" do
      OutOfOrderError
    end

    it "FactError" do
      FactError
    end

    it "ContextError" do
      ContextError
    end

    it "SubjectError" do
      SubjectError
    end

    it "PredicateError" do
      PredicateError
    end

    it "ObjectError" do
      ObjectError
    end
  end
end