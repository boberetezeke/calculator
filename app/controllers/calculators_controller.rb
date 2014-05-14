class CalculatorsController < ApplicationController
  # FIXME: implement filters
  #before_filter :load_calculator, only: [:show, :update]

  def show
    load_calculator
  end

  def index
    calculator = Calculator.create(guid: SecureRandom.hex)
    redirect_to calculator_path(id: calculator.guid)
  end

  def update
    load_calculator
    @calculator.update(calculator_params)
    @calculator.handle_key(params[:key]) if params[:key] 
    @calculator.save

    respond_to do |format|
      format.html { redirect_to calculator_path(id: @calculator.guid) }
      format.json { head :ok }
    end
  end

  private

  if RUBY_ENGINE != "opal"
  include CalculatorsControllerServer
  end

  def load_calculator
    id = params[:id]
    if /^\d+$/.match(id)
      @calculator = Calculator.find(params[:id])
    else
      @calculator = Calculator.where(guid: params[:id]).first
    end
  end
end

