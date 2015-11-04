class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notificationable, polymorphic: true

  scope :unread,    -> { where(read: false) }
  scope :read,      -> { where(read: true) }
  scope :opened,    -> { where(opened: true) }
  scope :unopened,  -> { where(opened: false) }
end
