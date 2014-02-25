module CalculatorController
  class Base  #< ActionController::Base
  end

  class Show
    def initialize(params)
      puts "Show#initialize"
      @params = params
      @calculator = Calculator.find(params['id'])
      #puts "calculator loaded: #{calculator_hash}"
      #@calculator = Calculator.new_from_json(calculator_hash)
    end

    def add_bindings
      puts "add_bindings"
      @calculator.save
      puts "calculator.accumulator = #{@calculator.accumulator}"

      @calculator.on_change(:current_entry) do |old_value, new_value|
        puts "old value = #{old_value}, new_value = #{new_value}"
        Element.find('#current_entry').value = new_value
      end

      @calculator.on_change(:accumulator) do |old_value, new_value|
        puts "accumulator new_value = #{new_value}"
        render_accumulator
      end

      @calculator.on_change(:current_operation) do |old_value, new_value|
        puts "current_operation new_value = #{new_value}"
        render_accumulator
      end

      (0..9).each do |key|
        Element.find("#keypad-#{key}").on(:click) do |event|
          @calculator.handle_key(key.to_s)
          puts "in key #{key} event handler"
          #event.stop_propagation
          false
        end
      end

      %w{plus minus times divide clear equal}.each do |key|
        puts "for key: #{key}"
        Element.find("#keypad-#{key}").on(:click) do |event|
          puts "operation key #{key} hit"
          @calculator.handle_key(key.to_s)
          #event.stop_propagation
          false
        end
      end
      
      Element.find("#tape").on(:click) do |event|
        puts "tape clicked"
        false
      end
    end

    def render_accumulator
      value = Template["views/calculators/partial"].render(self)
      #value = Template["views/calculators/accumulator"].render(self)
      puts "current_operation change: template value = #{value}"
      Element.find("#accumulator").html = value
    end
  end
end
