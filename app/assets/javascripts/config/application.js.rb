
class CalculatorApplication < Application
  def initialize
    super

    @memory_store.init_new_table("calculators")
    @memory_store.init_new_table("results")
  end
end


CalculatorApplication.routes.draw do |router|
  router.resources :calculators
  router.resources :results
end


