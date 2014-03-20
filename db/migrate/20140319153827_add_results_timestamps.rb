class AddResultsTimestamps < ActiveRecord::Migration
  def change
    add_timestamps :results
  end
end
