class AddNumberToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :number, :integer, default: 1
  end
end
