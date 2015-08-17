class AddEditedCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :edited_count, :integer, default: 0
  end
end
