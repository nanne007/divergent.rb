module Divergent
  ##
  # The module defines the interfaces that other class should implement.
  #
  # Examples:
  #
  # ```
  # Maybe.unit(1) # => Some(1)
  # Maybe.unit(1).fmap { |v| v + 1 } => Some(2)
  # ```
  module Monad
    def self.unit(v)
      raise NotImplementedError
    end

    def fmap(&f)
      raise NotImplementedError
    end
  end
end
