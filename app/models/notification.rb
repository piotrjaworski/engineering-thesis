class Notification < ActiveRecord::Base
  self.per_page = 6

  belongs_to :user
  belongs_to :notificationable, polymorphic: true

  scope :unread,    -> { where(read: false) }
  scope :read,      -> { where(read: true) }
  scope :opened,    -> { where(opened: true) }
  scope :unopened,  -> { where(opened: false) }

  def object
    self.notificationable_type.constantize.find(self.notificationable_id)
  end

  def unread?
    !self.read
  end

  def read?
    !!self.read
  end

  def object_class_name
    object.class.name
  end

  def mark_as_read
    self.update_attribute(:read, true)
  end

end
