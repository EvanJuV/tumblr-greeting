class AddColumnsToLists < ActiveRecord::Migration
  def change
    add_column :lists, :last_followers, :text
  end
end
