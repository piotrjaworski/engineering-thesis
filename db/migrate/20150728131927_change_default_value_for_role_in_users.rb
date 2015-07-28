class ChangeDefaultValueForRoleInUsers < ActiveRecord::Migration
  def change
    change_column :users, :role, :integer, default: 3
  end
end
