class DropLists < ActiveRecord::Migration
  def change
  	drop_table :lists
  end
end
