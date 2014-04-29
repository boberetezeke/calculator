class ResultsClientController < ApplicationController
  class Base  #< ActionController::Base
  end

  class Index
    def initialize(params)
    end

    def add_bindings
      Element.find("#back").on(:click) do |event|
        History.pop_state();
        Element.find("#results").hide
        Element.find("#calculator").show
        false
      end

      History.on_pop_state do
        Element.find("#results").hide
        Element.find("#calculator").show
      end
    end
  end
end
