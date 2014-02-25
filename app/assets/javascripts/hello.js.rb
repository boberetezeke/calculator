#require "test"
#require "erb"

puts "hello, there"

class A
  class B
  end
  def x
    eval("1+2")
  end
end

a = Object.const_get("A")
b = A.const_get("B")
puts "a = #{a.inspect}"
puts "b = #{b.inspect}"

class World
  def self.render_erb
    puts "in render_erb"

    @name = "world"
    val = Template["views/calculators/partial"].render(self)
    puts "val = #{val}"
    #Element.find("#stuff").html = val #Template["test"].render(self)
    #puts Element.find("#stuff").inspect
  end

  def self.f
    " is hot stuff"
  end
end

class Foo
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
end

foo = Foo.new(1,2)

Document.ready? do 
  World.render_erb
end



