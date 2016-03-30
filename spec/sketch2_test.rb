gem 'minitest', '~> 5.0'          # => true
require "minitest/autorun"        # => true
require "minitest/pride"          # => true
require_relative "../sketch2.rb"  # => true

class KanrenTest < Minitest::Test
  def test_it_has_basic_unions
    goal = K.run do |q|            # => K
      z = "hi"                     # => "hi"
      K.union q, z                 # => nil
    end                            # => nil

    assert_equal(["hi"], goal)
  end

  def test_it_has_union_chains
    goal = K.run do |q|         # => K
      x = K.fresh               # => #<Var:0x007fbb9a161ab8>
      z = "hi"                  # => "hi"
      K.union x, z              # => "hi"
      K.union z, q              # => nil
    end                         # => nil

    assert_equal(["hi"], goal)
  end

  def test_it_recursively_returns_unions
    goal = K.run do |q|                   # => K
      x = K.fresh                         # => #<Var:0x007fbb9a1530a8>
      z = K.fresh                         # => #<Var:0x007fbb9a152e78>
      K.union x, z                        # => #<Var:0x007fbb9a152e78>
      K.union 3, z                        # => 3
      K.union q, x                        # => nil
      q                                   # => #<Goal:0x007fbb9a1530f8 @values=[#<Var:0x007fbb9a152e78 @value=3>]>
    end                                   # => [3]

    assert_equal([3], goal)  # => true
  end

  def test_it_rejects_contradictory_unions
    goal = K.run do |y|
      K.union(4, y)
      K.union("hi", y)
    end

    assert_equal([], goal)
  end

  def test_it_has_basic_conds
    goal = K.run do |y|
      case_1 = lambda { K.union(4, y) }
      case_2 = lambda { K.union("hi", y) }
      K.cond(case_1, case_2)
    end

    assert_equal([4, "hi"], goal)
  end
end

# >> Run options: --seed 11903
# >>
# >> # Running:
# >>
# >> [41m[37mF[0m[41m[37mF[0m[38;5;154m.[0m
# >>
# >> [38;5;154mF[0m[38;5;154ma[0m[38;5;148mb[0m[38;5;184mu[0m[38;5;184ml[0m[38;5;214mo[0m[38;5;214mu[0m[38;5;208ms[0m[38;5;208m [0m[38;5;203mr[0m[38;5;203mu[0m[38;5;198mn[0m in 0.001250s, 2400.2573 runs/s, 2400.2573 assertions/s.
# >>
# >>   1) Failure:
# >> KanrenTest#test_it_has_union_chains [/Users/levkravinsky/Desktop/miniKanren/spec/sketch2_test.rb:24]:
# >> Expected: ["hi"]
# >>   Actual: nil
# >>
# >>
# >>   2) Failure:
# >> KanrenTest#test_it_has_basic_unions [/Users/levkravinsky/Desktop/miniKanren/spec/sketch2_test.rb:13]:
# >> Expected: ["hi"]
# >>   Actual: nil
# >>
# >> 3 runs, 3 assertions, 2 failures, 0 errors, 0 skips
