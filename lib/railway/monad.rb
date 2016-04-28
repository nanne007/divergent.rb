module Railway
  module Monad
    def self.unit(v)
      raise NotImplementedError
    end

    def fmap(&f)
      raise NotImplementedError
    end
  end
end
