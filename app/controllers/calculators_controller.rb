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
    @calculator.handle_key(params[:key])
    @calculator.save

    redirect_to calculator_path(@calculator)
  end
end

