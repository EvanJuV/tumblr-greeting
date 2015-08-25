class AddUserIdToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :user_id, :integer
  end
end
