module ActiveRecord
  class Base
    attr_accessor :attributes, :observers

    def self.new_from_json(json)
      object = self.new
      object.attributes = json
      object
    end

    def on_change(sym, &block)
      str = sym.to_s
      self.observers ||= {}
      self.observers[str] ||= []
      self.observers[str].push(block)
      puts "on_change: self.observers = #{self.observers.inspect}"
    end

    def method_missing(sym, *args)
      str = sym.to_s
      puts "method_missing: #{str}, #{attributes}"
      if m = /(.*)=$/.match(str)
        str = m[1]
        old_value = self.attributes[str]
        new_value = args.shift
        self.attributes[str] = new_value

        if self.observers[str] then
          self.observers[str].each do |observer|
            observer.call(old_value, new_value)
          end
        end
      else
        self.attributes[str]
      end
    end

    def self.has_many(name, options={})
      #@associations ||= []
      #@associations.push([:has_many, name, options])
    end

    def self.belongs_to(name, options={})
      #@associations ||= []
      #@associations.push([:belongs_to, name, options])
    end

    def self.after_initialize(sym)
      #@after_initialize_callback = sym
    end

    #def self.new(*args)
    #  super(*args)
    #end
  end
end
