class AddTypesToResults < ActiveRecord::Migration
  def change
    add_column :results, :type, :string
    add_column :results, :operation, :string
  end
end
