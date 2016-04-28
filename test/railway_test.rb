require 'test_helper'

class RailwayTest < Minitest::Test
  include Railway
  def test_that_it_has_a_version_number
    refute_nil ::Railway::VERSION
  end
end
