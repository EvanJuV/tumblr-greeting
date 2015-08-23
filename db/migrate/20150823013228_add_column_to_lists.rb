class AddColumnToLists < ActiveRecord::Migration
  def change
    add_column :lists, :user_id, :integer
    add_index :user_id
  end
end
