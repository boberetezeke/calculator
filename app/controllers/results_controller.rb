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

  def result_params
    #params.require(:result).permit(:operation, :result_type)
  end
end
