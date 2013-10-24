class Calculator < ActiveRecord::Base
  after_initialize :setup_defaults
  has_many :results

  def clear
    self.accumulator = 0.0 
    self.current_entry = ""
    self.current_operation = ""
  end

  private

  def setup_defaults
    self.accumulator ||= 0.0 
    self.current_entry ||= ""
    self.current_operation ||= ""
  end
end
