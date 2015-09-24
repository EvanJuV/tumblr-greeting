class AddIndexesToFollowers < ActiveRecord::Migration
  def change
  	add_index :followers, :id
  	add_index :followers, [:id, :blog_id]
  end
end
