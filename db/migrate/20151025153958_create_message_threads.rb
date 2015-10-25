class CreateMessageThreads < ActiveRecord::Migration
  def change
    create_table :message_threads do |t|
      t.references :sender, index: true
      t.references :addressee, index: true
      t.string :topic

      t.timestamps null: false
    end
    add_foreign_key :message_threads, :users, column: :sender_id, primary_key: :id
    add_foreign_key :message_threads, :users, column: :sender_id, primary_key: :id
  end
end
