module ActiveRecord
  class Base
    attr_accessor :attributes

    def self.new_from_json(json)
      object = self.new
      object.attributes = json
      object
    end

    def method_missing(sym, *args)
      str = sym.to_s
      puts "method_missing: #{str}, #{attributes}"
      if /=$/.match(str)
        self.attributes[str] = args.shift
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
