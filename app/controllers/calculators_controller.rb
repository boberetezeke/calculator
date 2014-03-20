class CalculatorsController < ApplicationController
  def show
    @calculator = Calculator.where(guid: params[:id]).first
  end

  def index
    calculator = Calculator.create(guid: SecureRandom.hex)
    redirect_to calculator_path(id: calculator.guid)
  end

  def update
    @calculator = Calculator.find(params[:id])
    @calculator.handle_key(params[:key])
    @calculator.save

    redirect_to calculator_path(id: @calculator.guid)
  end
end

