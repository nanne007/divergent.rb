require 'singleton'

require_relative 'errors'
require_relative 'monad'

module Railway
  ##
  # Represents optional values. Instances of Maybe
  #  are either an instance of Some or the object None.
  #
  #  The most idiomatic way to use an Maybe instance is to treat it
  #  as a collection or monad and use `map`, `fmap`, `filter`, or
  #  `each`.
  class Maybe
    include Monad

    ##
    # An Maybe factory which return None.
    # This always return the same None object.
    #
    # Example:
    #
    # ```
    # Maybe.empty == Maybe.empty
    # ```
    def self.empty
      None
    end

    ##
    # An factory which creates Some(v) if the argument is not nil,
    # and None if it is nil.
    #
    # Examples:
    #
    # ```
    # Maybe.unit(1)   # => Some(1)
    # Maybe.unit(nil) # => None
    # ```
    def self.unit(v)
      if v.nil?
        None
      else
        Some.new(v)
      end
    end

    ##
    # Returns the result of applying block to this Maybe value,
    # if this value is not empty.
    # Return `None` if this value is empty.
    #
    # Slightly different from `map` in that block is expected to
    # return an instance of `Maybe`.
    #
    # Examples
    #
    # ```
    # Maybe.unit(1).fmap { |v| Maybe.unit(v + 1) } # => Some(2)
    # some_hash = {}
    # Maybe.unit(:a).fmap { |v| Maybe.unit(some_hash[v]) } # => None
    # ```
    def fmap() # :yields: v
      if empty?
        None
      else
        yield(get)
      end
    end

    ##
    # Return true if the maybe is None, false otherwise.
    def empty?
      raise NotImplementedError
    end

    ##
    # Return the maybe's value.
    #
    # Notes:
    # the maybe should not be empty.
    #
    # otherwise, raise Standarderror.
    def get
      raise NotImplementedError
    end

    ##
    # Returns the maybe's value if the maybe is nonempty, otherwise
    # return the `v`.
    def get_or_else(v)
      if empty?
        v
      else
        get
      end
    end

    ##
    # Return this maybe id it is not empty,
    # else return the `v`.
    #
    # Note:
    # This is similar to Maybe#get_or_else,
    # but the v should be an instance of Maybe.
    def or_else(v)
      if empty?
        v
      else
        self
      end
    end

    ##
    # Return a Maybe containing the result of applying block to the maybe's value
    # if not empty.
    # Otherwise, return None.

    # Notes:
    # This is similar to +flat_map+ except here,
    # block does not need to wrap its result in a maybe.
    def map() # :yields: v
      if empty?
        None
      else
        Maybe.unit(yield get)
      end
    end


    ##
    # Return this maybe if it is not empty and the predicate block evals to true.
    # Otherwise, return None.
    def filter() # :yields: v
      if !empty? && yield(get)
        self
      else
        None
      end
    end

    ##
    # Test whether the maybe contains a given elem.
    #
    # Examples:
    #
    # ```
    # Maybe.unit(1).include?(1) #=> true
    # Maybe.unit(1).include?(2) #=> false
    # Maybe.empty.include?(1) #=> false
    # ```
    def include?(elem)
      !empty? && get == elem
    end

    ##
    # Return true if it is not empty and the predicate block evals to true.
    #
    # Examples:
    #
    # ```
    # Maybe.unit(1).any?{ |v| v == 1} #=> true
    # Maybe.unit(1).any?{ |v| v == 2} #=> false
    # Maybe.empty.any?{ |v| v == 1} #=> false
    # ```
    def any?() # :yields: v
      !empty? && yield(get)
    end

    ##
    # Return true if it is empty or the predicate block evals to true
    # when applying to the maybe's value.
    #
    # Examples:
    #
    # ```
    # Maybe.unit(1).all?{ |v| v == 1} #=> true
    # Maybe.unit(1).all?{ |v| v == 2} #=> false
    # Maybe.empty.all?{ |v| v == 1} #=> true
    # ```
    def all?() # :yields: v
      empty? || yield(get)
    end
    ##
    # Apply the given block to the maybe's value if not empty.
    # Otherwise, do nothing.
    def each() # :yields: v
      yield(get) unless empty?
    end

    ## Returns a singleton list containing the maybe's value
    #  if it is nonempty, or the empty list if empty.
    def to_a
      if empty?
        []
      else
        [get]
      end
    end
  end

  class Some < Maybe # :nodoc: all
    def initialize(v)
      raise 'value cannot be nil' if v.nil?
      @v = v
    end

    def empty?
      false
    end

    def get
      @v
    end

    def to_s
      "Some(#{@v.inspect})"
    end

    alias inspect to_s
  end

  None = Class.new(Maybe) do # :nodoc: all
    include Singleton

    def empty?
      true
    end

    def get
      raise NoSuchElementError, 'no such element in None.get'
    end

    def to_s
      "None"
    end

    alias inspect to_s
  end.instance.freeze
end

module Railway
  def Maybe(v)
    Maybe.unit(v)
  end

  module_function :Maybe
end
