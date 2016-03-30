class Var
  attr_accessor :name, :value
end

class K
  def self.run &block
    find_value block.call fresh
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
