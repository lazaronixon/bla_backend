class AddIndexToBorrowingsDueAt < ActiveRecord::Migration[8.1]
  def change
    add_index :borrowings, :due_at
  end
end
