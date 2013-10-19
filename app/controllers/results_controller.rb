class ResultsController < ApplicationController
  def index
    @results = Calculator.find(params[:calculator_id]).results.reverse
  end
end
