class Kanren
  def self.union(x, y)
    if x.class == Var && y.class != Var     # => true, false, false, false
      x.value = y                           # => 5
    elsif y.class == Var && x.class != Var  # => true, false, false
      y.value = x                           # => 7
    elsif y.class != Var && x.class != Var  # => true, false
      x == y ? "same" : "incompatible"      # => "incompatible"
    else
      "incompatible"                        # => "incompatible"
    end                                     # => 5, 7, "incompatible", "incompatible"
  end
end

class Var
  attr_accessor :name, :value  # => nil

  def initialize(s)
    @name = s        # => "a", "b"
  end

  def self.fresh(*strings)
    strings.map { |s| new(s) }  # => [#<Var:0x007f95aa921ca0 @name="a">], [#<Var:0x007f95aa9209b8 @name="b">]
  end

  def self.all
    ObjectSpace.each_object(self).to_a  # => [#<Var:0x007f95aa921ca0 @name="a">], [#<Var:0x007f95aa9209b8 @name="b">, #<Var:0x007f95aa921ca0 @name="a">]
  end

  def self.search(name)
    all.find(1) { |var| var.name == name }  # => #<Var:0x007f95aa921ca0 @name="a">, #<Var:0x007f95aa9209b8 @name="b">
  end
end

Var.fresh("a")       # => [#<Var:0x007f95aa921ca0 @name="a">]
a = Var.search("a")  # => #<Var:0x007f95aa921ca0 @name="a">

Var.fresh("b")       # => [#<Var:0x007f95aa9209b8 @name="b">]
b = Var.search("b")  # => #<Var:0x007f95aa9209b8 @name="b">

Kanren.union(a, 5)  # => 5
a.value             # => 5

Kanren.union(7, b)  # => 7
b.value             # => 7

Kanren.union(9, 10)  # => "incompatible"
Kanren.union(a, b)   # => "incompatible"

# lambda { |*x| x.each { |s| Var.new(s) } }.call("h", "z")   # => ["h", "z"]
# ObjectSpace.each_object(Var).to_a.find {|v| v.name = "z"}  # => #<Var:0x007fee6c02a4b0 @name="z">
