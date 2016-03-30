class Var
  attr_accessor :value
end

class Goal
  attr_accessor :values

  def initialize
    @values = []
  end
end

class K
  def self.run &block
    goal = Goal.new
    yield goal
    find_values goal
  end

  def self.fresh
    Var.new
  end

  def self.union x, y
    if unassigned? x, y
      assign x, y
    elsif x == y
      true
    else
      "uhhh"
    end
  end

  def self.unassigned? x, y
    if @branching && (x.class == Goal || y.class == Goal)
      assign_goal x, y
    elsif @branching
      true
    elsif empty_goal x, y
      assign_goal x, y
      false
    elsif empty_var x, y
      true
    elsif !empty_goal x, y
      unassign_goal x, y
    end
  end

  def self.empty_var x, y
    x.class == Var && x.value.nil? ||  y.class == Var && y.value.nil?
  end

  def self.empty_goal x, y
    (x.class == Goal && x.values.empty?) ||  (y.class == Goal && y.values.empty?)
  end

  def self.assign x, y
    if x.class == Var
      var, value = x, y
      var.value = value
    elsif y.class == Var
      var, value = y, x
      var.value = value
    end
  end

  def self.assign_goal x, y
    if x.class == Goal
      goal, var = x, y
      goal.values << (find_value var)
    elsif y.class == Goal
      goal, var = y, x
      goal.values << (find_value var)
    end
  end

  def self.unassign_goal x, y
    if x.class == Goal
      x.values = []
    elsif y.class == Goal
      y.values = []
    end
  end

  def self.find_values maybe_goal
    maybe_goal
    if maybe_goal.class == Goal
      maybe_goal.values.map do |value|
        find_value value
      end
    else
      maybe_goal
    end
  end

  def self.find_value maybe_var
    if maybe_var.class == Var && maybe_var.value.class == Var
      find_value maybe_var.value
    else
      maybe_var.class == Var ? maybe_var.value : maybe_var
    end
  end

  def self.cond *branches
    @branching = true
    branches.map do |branch|
      branch.call
    end
    @branching = false
  end
end
