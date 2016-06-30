require 'test_helper'

class DivergentTest < Minitest::Test
  include Divergent
  def test_that_it_has_a_version_number
    refute_nil ::Divergent::VERSION
  end
end
