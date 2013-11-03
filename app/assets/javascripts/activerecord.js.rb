module Arel
  class SelectManager
    attr_accessor :ordering, :limit, :offset
    attr_accessor :table_name, :node

    def initialize(connection, table_name)
      @connection = connection
      @table_name = table_name
    end

    def where(node)
      @node = node
    end

    def execute
      @connection.execute(self)
    end
  end

  module Nodes
    class BinaryOp
      attr_reader :left_node, :right_node
      def initialize(left_node, right_node)
        @left_node = left_node
        @right_node = right_node
      end
    end

    class And < BinaryOp
      def value(record)
        @left_node.value && @right_node.value
      end
    end

    class Or < BinaryOp
      def value(record)
        @left_node.value || @right_node.value
      end
    end

    class Equality < BinaryOp
      def value(record)
        @left_node.value == @right_node.value
      end
    end

    class NotEqual < BinaryOp
      def value(record)
        @left_node.value != @right_node.value
      end
    end

    class Literal
      attr_reader :value
      def initialize(value)
        @value = value
      end
    end

    class Symbol
      def initialize(symbol)
        @symbol = symbol
      end

      def value(record)
        record.send(@symbol)
      end
    end

    class Ordering
      attr_reader :order_str
      def initialize(order_str)
        @order_str = order_str
      end
    end

    class Limit
      attr_reader :limit
      def initialize(limit)
        @limit = limit
      end
    end
  end
end

module ActiveRecord
  class AssociationProxy
    def initialize(association_type, options, connection)
      @association_type = association_type
      @options = options
      @connection = connection
    end

    def all
      where(1 => 1)
    end

    def where(query={})
      Relation.new(query, @connection) 
    end

    def <<(assoc)

    end
  end

  class Relation
    def initalize(connection, table_name)
      @select_manager = Arel::SelectManager.new(connection, table_name)
    end

    def execute
      @records = @select_manager.execute
    end

    def where(query)
      key, value = query.first
      node = eq_node(key, value)
      query[1..-1].each do |key, value|
        node = Arel::Nodes::And.new(node, eq_node(key, value))
      end

      @select_manager.where(node)
    end

    def order(order_str)
      @select_manager.ordering = Arel::Nodes::Ordering.new(order_str)
      self
    end

    def limit(num)
      @select_manager.limit = Arel::Nodes::Limit.new(num)
      self
    end

    def offset(index)
      @select_manager.offset = Arel::Nodes::Offset.new(index)
      self
    end

    def first
      execute.first
    end

    def last
      execute.last
    end

    def [](index)
      execute[index]
    end

    def each
      execute.each { |record| yield record }
    end

    def eq_node(key, value)
      Arel::Nodes::Equal.new(Arel::Nodes::Symbol.new(key), Arel::Nodes::Literal(value))
    end
  end

  class MemoryStore
    def initialize
      @tables = {}
    end

    def execute(select_manager)
      @tables[select_manager.table_name].select do |record|
        select_manager.node.value(record)
      end
    end

    def push(table_name, record)
      @tables[table_name] ||= {}
      @tables[table_name][record.id] = record
    end

    def create(table_name, record)
      next_id = @next_ids[table_name]
      @next_ids[table_name] += 1
      @tables[table_name][next_id] = record
      return next_id
    end

    def update(table_name, record)
      @tables[table_name][record.id] = record
    end

    def destroy(table_name, record)
      @tables[table_name].delete(record.id)
    end
  end

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
        puts "self.class.associations = #{self.class.associations.inspect}"
        if assoc = self.class.associations[str]
          assoc
        else
          self.attributes[str]
        end
      end
    end

    def self.has_many(name, options={})
      @associations ||= {}
      @associations[name.to_s] = AssociationProxy.new(:has_many, options, @connection)
    end

    def self.belongs_to(name, options={})
      @associations ||= {}
      @associations[name.to_s] = AssociationProxy.new(:belongs_to, options, @connection)
    end
    
    def self.table_name
      self.to_s + "s"
    end

    def self.associations
      @associations
    end

    def self.after_initialize(sym)
      @after_initialize_callback = sym
    end

    def self.connection
      @connection || super
    end

    def self.connection=(connection)
      @connection = connection
    end

    def self.create(*args)
      obj = self.new(*args)
      obj.save
      obj
    end

=begin
    def self.method_missing(sym, *args)
      if [:first, :last, :all, :where].include?(sym)
        Relation.new(table_name).send(sym, *args)
      else
        super
      end
    end
=end

    def self.first
      Relation.new(@connection, table_name).first
    end

    def self.last
      Relation.new(@connection, table_name).last
    end

    def self.all
      Relation.new(@connection, table_name).all
    end

    def self.where(query={})
      Relation.new(@connection, table_name).where(query)
    end

    def self.new(*args)
      super(*args)
    end

    def initialize(initializers={})
      @attributes = {}
      @associations = {}
      initializers.each do |initializer, value|
        @attributes[initializer.to_s] = value
      end
    end

    def save
      @associations.select do |assoc|
        assoc.first == :belongs_to
      end.each do |assoc|
        @attributes["#{name}_id"] = self.id
      end 

      if self.id
        @connection.update(table_name, self)
      else
        @attributes['id'] = @connection.create(table_name, self)
      end
    end

    def destroy
      @connection.destroy(table_name, self)
    end

    def id
      @attributes['id']
    end

    def table_name
      self.class.table_name
    end

    def connection
      self.class.connection
    end
  end
end
