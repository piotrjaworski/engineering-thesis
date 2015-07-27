class AddViewsToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :views, :integer, default: 0
  end
end
