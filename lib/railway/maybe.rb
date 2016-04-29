require_relative 'monad'

module Railway
  class Maybe
    include Monad

    def self.empty
      None.instance
    end

    def self.unit(v)
      if v.nil?
        empty
      else
        Some.new(v)
      end
    end

    ## Returns the result of applying block to this `Maybe` value
    #  if this value is not empty.
    #  Return `None` if this value is empty.
    #  Slightly different from `map` in that block is expected to
    #  return an instance of `Maybe`.
    def fmap()
      if empty?
        None.instance
      else
        yield(get)
      end
    end

    def empty?
      raise NotImplementedError
    end

    def get
      raise NotImplementedError
    end

    def get_or_else(v)
      if empty?
        v
      else
        get
      end
    end

    def or_else(v)
      if empty?
        v
      else
        self
      end
    end

    def map()
      if empty?
        None.instance
      else
        Some.new(yield get)
      end
    end

    def filter()
      if !empty? && yield(get)
        self
      else
        None.instance
      end
    end

    def include?(elem)
      !empty? && get == elem
    end

    def any?()
      !empty? && yield(get)
    end

    def all?()
      empty? || yield(get)
    end

    def each()
      yield(get) unless empty?
    end

    def to_a
      if empty?
        []
      else
        [get]
      end
    end
  end

  class Some < Maybe
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
  end

  class None < Maybe
    include Singleton

    def empty?
      true
    end

    def get
      raise StandardError, 'no such element in None.get'
    end
  end
end
