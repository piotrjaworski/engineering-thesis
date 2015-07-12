class Topic < ActiveRecord::Base
  belongs_to :category
  belongs_to :user, class_name: 'User', foreign_key: 'creator_id'
end
