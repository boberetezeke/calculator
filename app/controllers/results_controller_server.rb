module ResultsControllerServer
  def result_params
    params.require(:result).permit(:operation, :result_type, :value, :calculator_id)
  end
end
