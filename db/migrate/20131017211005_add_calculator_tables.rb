class AddCalculatorTables < ActiveRecord::Migration
  def change
    create_table :calculators do |t|
      t.string :guid
      t.float  :accumulator
      t.string :current_entry
      t.string :current_operation
    end

    create_table :memory_locations do |t|
      t.integer :calculator_id
    end

    create_table :results do |t|
      t.float :value
      t.integer :calculator_id
    end
  end
end
