require_relative 'monad'

module Railway
  module Try
    include Monad
    def self.unit(v)
      Success.new(v)
    end

    def failure?
      raise NotImplementedError
    end

    def success?
      raise NotImplementedError
    end

    def get_or_else(v)
      if success?
        get
      else
        v
      end
    end

    def or_else(v)
      if success?
        self
      else
        raise 'else value should be a Try' unless v.is_a? Try
        v
      end
    end

    def get
      raise NotImplementedError
    end

    def each(&block)
      raise NotImplementedError
    end

    def map(&block)
      raise NotImplementedError
    end

    def filter(&block)
      raise NotImplementedError
    end

    def recover_with(&block)
      raise NotImplementedError
    end

    def recover(&block)
      raise NotImplementedError
    end

    def flatten
      raise NotImplementedError
    end

    def failed
      raise NotImplementedError
    end

    def transform(s, f)
      raise NotImplementedError
    end
  end

  class Success
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
        Failure.new(StandardError.new("Predicate does not hold for #{@value}"))
      end
    end

    def recover_with(&block)
      self
    end

    def recover(&block)
      self
    end

    def failed
      Failure.new(StandardError.new('Success.failed not supported'))
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
  end

  class Failure
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
  end
end


module Railway
  def Try
    Success.new(yield)
  rescue => e
    Failure.new(e)
  end
  module_function :Try
end
