class AddBlogIdToFollowers < ActiveRecord::Migration
  def change
    add_column :followers, :blog_id, :integer
  end
end
