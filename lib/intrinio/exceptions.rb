module Intrinio
  class BadResponse < StandardError; end
  class IncompatibleResponse < StandardError; end
  class MissingAuth < StandardError; end
end