class Calculator < ActiveRecord::Base
  after_initialize :setup_defaults
  has_many :results

  def clear
    self.accumulator = 0.0 
    self.current_entry = ""
    self.current_operation = ""
  end


  def handle_key(key)
    puts "in handle_key"
    case key
    when /^clear$/
      #self.results << Result.create(result_type: 'operation', operation: '--clear--')
      #self.results << Result.create(result_type: 'value', value: 0.0)
      self.clear
    when /^\d$/
      puts "in number"
      self.current_entry += key
    when /^equal$/
      puts "in equal"
      value = self.current_entry.to_f
      #self.results << Result.create(result_type: 'value', value: value)
      apply_operation(self.current_operation, value)
      #self.results << Result.create(result_type: 'operation', operation: '=')
      #self.results << Result.create(result_type: 'value', value: self.accumulator)
      self.current_entry = ""
      self.current_operation = ""
    when /^(plus|minus|times|divide)$/
      puts "in operation"
      value = self.current_entry.to_f
      accumulator_changed = false
      puts "value = #{value}"
      if self.current_operation.present?
        puts "no current_operation present"
        apply_operation(self.current_operation, value)
        puts "new accumulator = #{self.accumulator}"
        accumulator_changed = true
      else
        puts "current operation present"
        if self.current_entry.present?
          #self.results << Result.create(result_type: 'operation', operation: '---')
          self.accumulator = value
          accumulator_changed = true
        end
      end
      if accumulator_changed
        #self.results << Result.create(result_type: 'value', value: self.accumulator)
      end
      self.current_operation = key
      #self.results << Result.create(result_type: 'operation', operation: key)
      self.current_entry = ""
    else
      puts "in else case"
    end
  end

  private

  def apply_operation(operation, value)
    case operation
    when /plus/
      self.accumulator += value
    when /minus/
      self.accumulator -= value
    when /times/
      self.accumulator *= value
    when /divide/
      self.accumulator /= value
    end
  end

  def setup_defaults
    self.accumulator ||= 0.0 
    self.current_entry ||= ""
    self.current_operation ||= ""
  end
end
