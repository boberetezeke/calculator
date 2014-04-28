module ResultsControllerServer
  def result_params
    params.require(:result).permit(:operation, :result_type)
  end
end
