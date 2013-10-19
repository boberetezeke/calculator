class InlineWidget
  def initialize(context, widget, in_edit_mode)
    @context = context
    @widget = widget
    @in_edit_mode = in_edit_mode
  end

  def render
    if @in_edit_mode then
      @context.render :partial => "widgets/form", :locals => {control: self, widget: @widget}
    else
      @context.render :partial => "widgets/show", :locals => {control: self, widget: @widget}
    end
  end
    
  def widget_id
    "widget_#{@widget.id}"
  end

  def widget_save_id
    "#{widget_id}_save"
  end

  def widget_show_class
    "#{widget_id}_show"
  end

  def widget_save_id_selector
    "##{widget_id}_save"
  end

  def register_for_events
    puts "registering for events"
    Element.find(widget_save_id_selector).on(:click) do |event|
      puts "clicked"
      event.kill
    end
    # Element(widget_id_selector).on_click{|event| on_click(event)}
  end

  def on_save
    # post = Ajax.post("widgets/create")
    # post.on_error do
    #   @context.render :partial => "widgets/form"
    # end
    # post.on_success do
    #   @context.render :partial => "widgets/show"
    # end
  end
end
