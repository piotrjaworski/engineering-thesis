class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.string :description
      t.integer :creator_id
      t.boolean :blocked
      t.references :category, index: true

      t.timestamps null: false
    end
    add_foreign_key :topics, :categories
  end
end
