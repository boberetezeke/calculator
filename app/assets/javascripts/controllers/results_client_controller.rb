class ResultsClientController < ApplicationController
  class Base  #< ActionController::Base
  end

  class Index < ActionController::Base
    def initialize(params)
      super 

      @calculator = Calculator.find(params[:calculator_id])
    end

    def add_bindings
      Element.find("#back").on(:click) do |event|
        begin
          puts "on click back"
          #History.pop_state();
          instance = Application.instance
          puts "before route"
          route = calculator_path(@calculator.guid)
          puts "route = #{route}"
          instance.go_to_route(route, render_view: true, selector: "#calculator")

          Element.find("#results").hide
          Element.find("#calculator").show
        rescue Exception => e
          puts "Exception: #{e}"
          e.backtrace.each do |trace|
            puts trace
          end
        end
        false
      end

      History.on_pop_state do
        Element.find("#results").hide
        Element.find("#calculator").show
      end
    end
  end
end
