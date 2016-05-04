require_relative 'errors'
require_relative 'monad'

module Railway
  ##
  # The `Try` type represents a computation that
  # may either result in an exception, or return a
  # successfully computed value.
  # It's similar to, but semantically different from Either.
  #
  # Instances of Try, are either an instance of Success or Failure.
  #
  # For example, `Try` can be used to perform division on a user-defined input,
  # without the need to do explicit exception-handling in
  # all of the places that an exception might occur.
  module Try
    include Monad
    def self.unit(v)
      Success.new(v)
    end

    # Returns `true` if the `Try` is a `Failure`, `false` otherwise.
    def failure?
      raise NotImplementedError
    end

    # Returns `true` if the `Try` is a `Success`, `false` otherwise.
    def success?
      raise NotImplementedError
    end

    # Returns the value from this `Success`
    # or the given `default` argument if this is a `Failure`.
    def get_or_else(default)
      if success?
        get
      else
        default
      end
    end

    # Returns this `Try` if it's a `Success`
    # or the given `default` argument if this is a `Failure`.
    #
    # Notes: the `default` value should be an instance of Try.
    def or_else(default)
      if success?
        self
      else
        default
      end
    end

    # Returns the value from this `Success`
    # or throws the exception if this is a `Failure`.
    def get
      raise NotImplementedError
    end

    ##
    # Applies the given block if this is a `Success`,
    # otherwise returns `Unit` if this is a `Failure`.
    #
    # Notes:
    #
    # If block throws, then this method may throw an exception.
    def each(&block)
      raise NotImplementedError
    end

    ##
    # Maps the given function to the value from this `Success`
    # or returns this if this is a `Failure`.
    def map(&block)
      raise NotImplementedError
    end

    # Converts this to a `Failure` if the predicate is not satisfied.
    def filter(&block)
      raise NotImplementedError
    end

    # Applies the given block if this is a `Failure`,
    # otherwise returns this if this is a `Success`.
    #
    # Notes: block call should return an instance of Try.
    # This is like `fmap` for the exception.
    def recover_with(&block)
      raise NotImplementedError
    end

    # Applies the given block if this is a `Failure`,
    # otherwise returns this if this is a `Success`.
    #
    # This is like `fmap` for the exception.
    def recover(&block)
      raise NotImplementedError
    end

    # Transforms a nested `Try` into an un-nested `Try`.
    def flatten
      raise NotImplementedError
    end

    ##
    # Inverts this `Try`. If this is a `Failure`, returns its exception wrapped in a `Success`.
    # If this is a `Success`, returns a `Failure` containing an UnSupportedOperationError.
    def failed
      raise NotImplementedError
    end

    ##
    # Completes this `Try` by applying the function `f` to this if this is of type `Failure`,
    # or conversely, by applying `s` if this is a `Success`.
    def transform(s, f)
      raise NotImplementedError
    end
  end

  class Success # :nodoc: true
    include Try

    def initialize(value)
      @value = value
    end

    def fmap()
      begin
        yield @value
      rescue => e
        Failure.new(e)
      end
    end

    def success?
      true
    end

    def failure?
      false
    end

    def get
      @value
    end

    def each()
      yield(@value)
      nil
    end

    def map()
      t = begin
            yield(@value)
          rescue => e
            Failure.new(e)
          end

      Success.new(t)
    end

    def filter()
      p = begin
            yield(@value)
          rescue => e
            return Failure.new(e)
          end
      if p
        self
      else
        Failure.new(NoSuchElementError.new("Predicate does not hold for #{@value}"))
      end
    end

    def recover_with(&block)
      self
    end

    def recover(&block)
      self
    end

    def failed
      Failure.new(UnSupportedOperationError.new('Success.failed'))
    end

    def transform(s, _f)
      begin
        s.call(@value)
      rescue => e
        Failure.new(e)
      end
    end

    def flatten
      if @value.is_a? Try
        @value
      else
        self
      end
    end

    def to_s
      "Success<#{@value}>"
    end

    alias inspect to_s
  end

  class Failure # :nodoc: true
    include Try
    def initialize(error)
      raise 'error should be an StandardError' unless error.is_a? StandardError
      @error = error
    end

    def fmap()
      self
    end

    def failure?
      true
    end

    def success?
      false
    end

    def get
      raise @error
    end

    def each(&block)
      nil
    end

    def map(&block)
      self
    end

    def filter(&block)
      self
    end

    def recover_with()
      begin
        yield(@error)
      rescue => e
        Failure.new(e)
      end
    end

    def recover()
      t = yield(@error)
      Success.new(t)
    rescue => e
      return Failure.new(e)
    end

    def failed
      Success.new(@error)
    end

    def transform(_s, f)
      begin
        f.call(@error)
      rescue => e
        Failure.new(e)
      end
    end

    def flatten
      self
    end

    def to_s
      "Failure<#{@error}>"
    end

    alias inspect to_s
  end
end


module Railway
  ##
  # Constructs a `Try` by calling the passed block.  This
  # method will ensure any StandardError is caught and a
  # `Failure` object is returned.
  def Try
    Success.new(yield)
  rescue => e
    Failure.new(e)
  end
  module_function :Try
end
