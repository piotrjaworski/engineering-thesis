class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :notificationable_type
      t.integer :notificationable_id
      t.references :user, index: true
      t.string :name
      t.boolean :read, default: false
      t.boolean :opened, default: false

      t.timestamps null: false
    end
    add_index :notifications, :notificationable_id
    add_foreign_key :notifications, :users
  end
end
