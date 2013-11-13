class AddTestTables < ActiveRecord::Migration
  def change
    create_table :as do |t|
      t.integer :x
      t.integer :y
    end
    create_table :bs do |t|
      t.integer :x
      t.integer :y
    end
    create_table :cs do |t|
      t.integer "b_id"
      t.integer :x
      t.integer :y
    end
  end
end
