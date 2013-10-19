json.array!(@widgets) do |widget|
  json.extract! widget, :name, :color
  json.url widget_url(widget, format: :json)
end
