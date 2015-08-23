class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.string :followers

      t.timestamps null: false
    end
  end
end
