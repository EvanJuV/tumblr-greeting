class AddNewFollowersToUsers < ActiveRecord::Migration
  def change
    add_column :lists, :new_followers, :text
  end
end
