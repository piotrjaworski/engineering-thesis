class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.boolean :post_notifications, default: true
      t.boolean :message_notifications, default: true
      t.text :signature
      t.string :webpage
      t.string :location
      t.text :about_me

      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end
