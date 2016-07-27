module Divergent
  ##
  # The module defines the interfaces that other class should implement.
  #
  # Examples:
  #
  #
  #   Maybe.unit(1) # => Some(1)
  #   Maybe.unit(1).fmap { |v| v + 1 } => Some(2)
  #
  module Monad
    module InstanceMethods
      def fmap(&f)
        raise NotImplementedError
      end
    end

    module ClassMethods
      def unit(v)
        raise NotImplementedError
      end
    end

    def self.included(subclass)
      subclass.extend ClassMethods
      subclass.include InstanceMethods
    end
  end
end
