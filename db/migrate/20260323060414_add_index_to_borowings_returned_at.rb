class AddIndexToBorowingsReturnedAt < ActiveRecord::Migration[8.1]
  def change
    add_index :borrowings, :returned_at
  end
end
