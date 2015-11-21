class RemoveLocationWebpageAndSignatureFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :location, :string
    remove_column :users, :signature, :string
    remove_column :users, :webpage, :string
  end
end
