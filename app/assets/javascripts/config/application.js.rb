
class CalculatorApplication < Application
  def initialize
    super

    @store.init_new_table("calculators")
    @store.init_new_table("results")
  end

  def get_store
    ActiveRecord::LocalStorageStore.new(LocalStorage.new)
  end
end


CalculatorApplication.routes.draw do |router|
  router.resources :calculators
  router.resources :results
end


