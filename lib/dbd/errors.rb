module Dbd

  class OutOfOrderError < StandardError ; end
  class FactError < StandardError ; end

  class ContextError < StandardError ; end
  class SubjectError < StandardError ; end
  class PredicateError < StandardError ; end
  class ObjectTypeError < StandardError ; end
  class ObjectError < StandardError ; end

end
