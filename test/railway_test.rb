require 'test_helper'

class RailwayTest < Minitest::Test
  include Railway
  def test_that_it_has_a_version_number
    refute_nil ::Railway::VERSION
  end

  def test_try_me
    v = Try { 'success' }
    assert v.is_a? Try
    assert v.success?
    assert 'success', v.get
  end
end
