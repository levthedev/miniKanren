class Var
  attr_accessor :name, :value
end

class K
  def self.run goal, &block
    goal = fresh
    find_value block.call goal
  end

  def self.fresh
    Var.new
  end

  def self.union x, y
    assign x, y if unassigned? x, y
  end

  def self.unassigned? x, y
    return true if x.class == Var || y.class == Var
  end

  def self.assign x, y
    if x.class == Var
      var, value = x, y
    else
      var, value = y, x
    end
    var.value = value
  end

  def self.find_value maybe_var
    if maybe_var.class == Var && maybe_var.value.class == Var
      find_value maybe_var.value
    else
      maybe_var.class == Var ? maybe_var.value : maybe_var
    end
  end
end

def solve_equation(equation)
  K.run "x" do |x|
    K.union x, balanced(equation)
    x
  end
end

def balanced(equation)
  parts = equation.split "="
  other_part = parts.find {|str| !str.include? "x"}
  solved_other_part = eval(other_part)

  x_part = parts.find {|str| str.include? "x"}
  non_x = x_part.delete("x")
  inverted = non_x.gsub("+", "-")
  # num = non_x.match(/\d+/).to_s                 # => "4"
  # sign = non_x.delete(num)                      # => "-"
  eval("#{solved_other_part}#{non_x}")
end

solve_equation("x-4+3=10*3-2")
