class ResultsController < ApplicationController
  def index
    @calculator = Calculator.find(params[:calculator_id])
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
end
