module Railway
  module Try
    def failure?
      raise NotImplementedError
    end

    def success?
      raise NotImplementedError
    end

    def get_or_else(&block)
      if success?
        get
      else
        block.call
      end
    end

    def or_else(&block)
      begin
        if success?
          self
        else
          block.call
        end
      rescue => e
        Failure.new(e)
      end
    end

    def get
      raise NotImplementedError
    end

    def each(&block)
      raise NotImplementedError
    end

    def flat_map(&block)
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
      begin
        if is_a? Success
          s.call(self.value)
        else
          f.call(self.error)
        end
      rescue => e
        Failure.new(e)
      end
    end
  end

  class Failure
    include Try

    attr_reader :error
    def initialize(error)
      @error = error
    end

    def failure?
      true
    end

    def success?
      false
    end

    def get
      raise error
    end

    def each(&block)
      nil
    end

    def flat_map(&block)
      self
    end

    def map(&block)
      self
    end

    def filter(&block)
      self
    end

    def recover_with(&block)
      t = begin
           block.call(error)
          rescue => e
            return Failure.new(e)
          end

      raise 'invalid return' unless t.is_a? Try

      t
    end

    def recover(&block)
      t = begin
            block.call(error)
          rescue => e
            return Failure.new(e)
          end

      Success.new(t)
    end

    def failed
      Success.new(error)
    end
  end

  class Success
    include Try

    attr_reader :value
    def initialize(value)
      @value = value
    end

    def success?
      true
    end

    def failure?
      false
    end

    def get
      value
    end

    def each(&block)
      block.call(value)
      nil
    end

    def flat_map(&block)
      begin
        block.call(value)
      rescue => e
        Failure.new(e)
      end
    end

    def map(&block)
      t = begin
            block.call(value)
          rescue => e
            Failure.new(e)
          end

      Success.new(t)
    end

    def filter(&block)
      begin
        if block.call(value)
          self
        else
          Failure.new(new StandardError("Predicate does not hold for #{value}"))
        end
      rescue => e
        Failure.new(e)
      end
    end

    def recover_with(&block)
      self
    end

    def recover(&block)
      self
    end

    def failed
      Failure.new(new StandardError('Success.failed not supported'))
    end
  end


  def Try(&block)
    Success.new(block.call)
  rescue => e
    Failure.new(e)
  end

  module_function :Try
end
