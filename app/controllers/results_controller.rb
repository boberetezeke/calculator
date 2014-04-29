class ResultsController < ApplicationController
  def index
    @calculator = load_calculator(params[:calculator_id])
    @results = @calculator.results.reverse
  end

  def create
    result = Result.create(result_params)
    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

  if RUBY_ENGINE != "opal"
  include ResultsControllerServer
  end

  def load_calculator(id)
    if /^\d+$/.match(id)
      @calculator = Calculator.find(id)
    else
      @calculator = Calculator.where(guid: id).first
    end
  end
end
