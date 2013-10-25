module CalculatorController
  class Base  #< ActionController::Base
  end

  class Show
    def initialize(calculator_hash)
      puts "calculator loaded: #{calculator_hash}"
      @calculator = Calculator.new_from_json(calculator_hash)
      puts "calculator.accumulator = #{@calculator.accumulator}"

      @calculator.on_change(:current_entry) do |old_value, new_value|
        puts "old value = #{old_value}, new_value = #{new_value}"
        Element.find('#current_entry').value = new_value
      end
      (0..9).each do |key|
        Element.find("#keypad-#{key}").on(:click) do |event|
          @calculator.current_entry += key.to_s
          puts "in key #{key} event handler"
          false
        end
      end
    end
  end
end
