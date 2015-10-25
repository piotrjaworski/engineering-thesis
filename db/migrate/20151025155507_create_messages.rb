class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.references :addressee, index: true
      t.references :sender, index: true
      t.references :message_thread, index: true
      t.boolean :read

      t.timestamps null: false
    end
    add_foreign_key :messages, :users, column: :sender_id, primary_key: :id
    add_foreign_key :messages, :users, column: :addressee_id, primary_key: :id
    add_foreign_key :messages, :message_threads
  end
end
