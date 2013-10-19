class WidgetController
  def self.load_and_start(widgets_json, action, id)
    #Widget.update(widgets_json)
    #WidgetController.new(widgets).send(action, id)
  end

  def initialize(widgets)
    @widgets = widgets
    puts "widgets = #{widgets.inspect}"
  end

  def show(id)
    @widget = Widget.find(id)
    Template["show"].render(self)
  end

  def edit(id)
    @widget = Widget.find(id)
    Template["edit"].render(self)
  end

  def edit_widget_path(widget)
    "/widgets/#{widget.id}"
  end

  def widgets_path
    "/widgets"
  end
end
