class RenameResultType < ActiveRecord::Migration
  def change
    rename_column :results, :type, :result_type
  end
end
