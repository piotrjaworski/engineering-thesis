class RemovePositionFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :position, :integer
  end
end
