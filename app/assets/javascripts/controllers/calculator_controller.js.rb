module CalculatorController
  class Base  #< ActionController::Base
  end

  class Show
    def initialize(calculator_json)
      #@calculator = calculator
      puts "calculator loaded: #{calculator_json}"
      @calculator = Calculator.new_from_json(calculator_json)
      puts "calculator.accumulator = #{@calculator.accumulator}"
    end
  end
end
