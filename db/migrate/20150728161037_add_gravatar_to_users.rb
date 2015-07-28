class AddGravatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gravatar, :boolean, default: false
  end
end
