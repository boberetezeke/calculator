class RemoveTestTables < ActiveRecord::Migration
  def change
    drop_table "as"
    drop_table "bs"
    drop_table "cs"
    drop_table "ds"
    drop_table "es"
  end
end
