class CalculatorsController < ApplicationController
  def show
    @calculator = Calculator.first
  end

  def index
    Calculator.create unless Calculator.first
    redirect_to Calculator.first
  end

  def update
    @calculator = Calculator.find(params[:id])
    case params[:key]
    when /^clear$/
      @calculator.results << Result.create(result_type: 'operation', operation: '--clear--')
      @calculator.results << Result.create(result_type: 'value', value: 0.0)
      @calculator.clear
    when /^\d$/
      @calculator.current_entry += params[:key]
    when /^=$/
      value = @calculator.current_entry.to_f
      @calculator.results << Result.create(result_type: 'value', value: value)
      eval("@calculator.accumulator #{@calculator.current_operation}= value")
      @calculator.results << Result.create(result_type: 'operation', operation: '=')
      @calculator.results << Result.create(result_type: 'value', value: @calculator.accumulator)
      @calculator.current_entry = ""
      @calculator.current_operation = ""
    when /^[+*\/-]$/
      value = @calculator.current_entry.to_f
      accumulator_changed = false
      if @calculator.current_operation.present?
        eval("@calculator.accumulator #{@calculator.current_operation}= value")
        accumulator_changed = true
      else
        if @calculator.current_entry.present?
          @calculator.results << Result.create(result_type: 'operation', operation: '---')
          @calculator.accumulator = value
          accumulator_changed = true
        end
      end
      if accumulator_changed
        @calculator.results << Result.create(result_type: 'value', value: @calculator.accumulator)
      end
      @calculator.current_operation = params[:key]
      @calculator.results << Result.create(result_type: 'operation', operation: params[:key])
      @calculator.current_entry = ""
    end
    @calculator.save

    redirect_to calculator_path(@calculator)
  end
end
