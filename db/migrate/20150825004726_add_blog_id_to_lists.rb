class AddBlogIdToLists < ActiveRecord::Migration
  def change
    add_column :lists, :blog_id, :integer
  end
end
