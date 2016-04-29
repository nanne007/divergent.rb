require 'test_helper'

class MaybeTest < Minitest::Test
  Maybe = Railway::Maybe

  def test_empty
    assert Maybe.empty.empty?
  end

  def test_unit
    assert Maybe.unit(nil).empty?
    assert !Maybe.unit(1).empty?
  end

  def test_fmap
    m = Maybe.unit(1)
    assert_equal Maybe.empty, m.fmap { |v| Maybe.empty }
    assert_equal 1, m.fmap { |v| Maybe.unit(v) }.get
  end

  def test_empty
    assert Maybe.empty.empty?
    assert !Maybe.unit(1).empty?
  end

  def test_get
    assert 1, Maybe.unit(1).get
    assert_raises {
      Maybe.unit(nil).get
    }
  end

  def test_get_or_else
    assert_equal 1, Maybe.unit(1).get_or_else(2)
    assert_equal 2, Maybe.empty.get_or_else(2)
  end

  def test_or_else
    m = Maybe.unit(1)

    assert_equal m, m.or_else(Maybe.unit(2))
    assert_equal m, Maybe.empty.or_else(m)
  end

  def test_map
    assert_equal Maybe.empty, Maybe.empty.map { |v| v + 1}
    assert_equal 2, Maybe.unit(1).map { |v| v + 1}.get
  end

  def test_filter
    assert_equal Maybe.empty, Maybe.empty.filter { |v| v == 1}
    assert_equal Maybe.empty, Maybe.unit(1).filter { |v| v != 1}
    assert_equal 1, Maybe.unit(1).filter { |v| v == 1}.get
  end

  def test_include
    assert Maybe.unit(1).include?(1)
    assert !Maybe.unit(1).include?(2)
    assert !Maybe.empty.include?(1)
  end

  def test_any
    assert Maybe.unit(1).any? { |v| v == 1}
    assert !Maybe.unit(2).any? { |v| v == 1}
    assert !Maybe.empty.any? { |v| v == 1}
  end

  def test_all
    assert Maybe.unit(1).all? { |v| v == 1}
    assert !Maybe.unit(2).all? { |v| v == 1}
    assert Maybe.empty.all? { |v| v == 1}
  end

  def test_each
    t = nil
    Maybe.unit(1).each { |v| t = v }
    assert_equal 1, t

    called = false
    Maybe.empty.each { |v| called = true}
    assert !called
  end

  def test_to_a
    assert_equal [1], Maybe.unit(1).to_a
    assert_equal [], Maybe.empty.to_a
  end

end
