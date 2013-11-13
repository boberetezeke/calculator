class AddMoreTestsTables < ActiveRecord::Migration
  def change
    create_table :ds do |t|
      t.integer :c_id
      t.integer :e_id
      t.integer :x
      t.integer :y
    end

    create_table :es do |t|
      t.integer :x
      t.integer :y
    end
  end
end
