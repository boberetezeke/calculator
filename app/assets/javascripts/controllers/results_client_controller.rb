class ResultsClientController < ApplicationController
  class Base  #< ActionController::Base
  end

  class Index
    def initialize(params)
    end

    def add_bindings
      Element.find("#back").on(:click) do |event|
        Element.find("#results").hide
        Element.find("#calculator").show
        false
      end
    end
  end
end
