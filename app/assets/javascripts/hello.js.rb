#require "test"
#require "erb"

puts "hello, there"

class World
  def self.render_erb
    puts "in render_erb"

    @name = "world"
    val = Template["test"].render(self)
    puts "val = #{val}"
    Element.find("#stuff").html = val #Template["test"].render(self)
    puts Element.find("#stuff").inspect
  end
end

class Foo
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
end

foo = Foo.new(1,2)

#module WidgetsController
#  class Show
#    def initialize(widget)
#      @widget = widget
#      Element.find("#edit")
#    end
#
#    def render
#      Template["show"].render(self)
#    end
#
#    def 
#  end
#
#  class Edit
#    def initialize(widget)
#      @widget = widget
#    end
#
#    def render
#      Template["edit"].render(self)
#    end
#  end
#end
#
#class WidgetController
#  def self.load_and_start(widgets, action, id)
#    WidgetController.new(widgets).send(action, id)
#  end
#
#  def initialize(widgets)
#    @widgets = widgets
#    puts "widgets = #{widgets.inspect}"
#  end
#
#  def show(widget)
#    @widget = widget
#    Template["show"].render(self)
#  end
#
#  def edit(widget)
#    @widget = widget
#    Template["edit"].render(self)
#  end
#
#  def edit_widget_path(widget)
#    "/widgets/#{widget.id}"
#  end
#
#  def widgets_path
#    "/widgets"
#  end
#end


Document.ready? do 
  World.render_erb
end



