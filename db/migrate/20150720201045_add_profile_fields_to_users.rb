class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :full_name, :string
    add_column :users, :location, :string
    add_column :users, :webpage, :string
    add_column :users, :signature, :string
  end
end
