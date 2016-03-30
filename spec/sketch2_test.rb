gem 'minitest', '~> 5.0'
require "minitest/autorun"
require "minitest/pride"
require_relative "../sketch2.rb"

class KanrenTest < Minitest::Test
  def test_it_has_basic_unions
    goal = K.run do |q|
      z = "hi"
      K.union q, z
    end

    assert_equal("hi", goal)
  end

  def test_it_has_union_chains
    goal = K.run do |q|
      x = K.fresh
      z = "hi"
      K.union x, z
      K.union z, q
    end

    assert_equal("hi", goal)
  end

  def test_it_recursively_returns_unions
    goal = K.run do |q|
      x = K.fresh
      z = K.fresh
      K.union x, z
      K.union 3, z
      K.union q, x
      q
    end

    assert_equal(3, goal)
  end
end
