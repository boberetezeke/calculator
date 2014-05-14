module CalculatorsControllerServer
  def calculator_params
    params.require(:calculator).permit(:current_entry, :accumulator, :current_operation)
  end
end
