module ResultsControllerServer
  def result_params
    params.require(:result).permit(:operation, :result_type, :calculator_id)
  end
end
