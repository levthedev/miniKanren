class Var
  attr_accessor :name, :value  # => nil
end

class K
  def self.run &block
    find_value block.call fresh  # => []
  end

  def self.fresh
    Var.new       # => #<Var:0x007fc61202e560>
  end

  def self.union x, y
    assign x, y if unassigned? x, y  # => 4, []
  end

  def self.unassigned? x, y
    return true if x.class == Var || y.class == Var  # => true, true
  end

  def self.assign x, y
    if x.class == Var && x.value.nil?     # => true, false
      var, value = x, y                   # => [#<Var:0x007fc61202e560>, 4]
      var.value = value                   # => 4
    elsif y.class == Var && y.value.nil?  # => false
      var, value = y, x
      var.value = value
    else
      []                                  # => []
    end                                   # => 4, []
  end

  def self.find_value maybe_var
    if maybe_var.class == Var && maybe_var.value.class == Var  # => false
      find_value maybe_var.value
    else
      maybe_var.class == Var ? maybe_var.value : maybe_var     # => []
    end                                                        # => []
  end
end

K.run do |y|     # => K
  K.union(y, 4)  # => 4
  K.union(y, 5)  # => []
end              # => []
