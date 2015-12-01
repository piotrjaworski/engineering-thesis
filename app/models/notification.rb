class Notification < ActiveRecord::Base
  self.per_page = 6

  belongs_to :user
  belongs_to :notificationable, polymorphic: true

  default_scope { order(updated_at: :desc) }
  scope :unread,    -> { where(read: false) }
  scope :read,      -> { where(read: true) }

  def object
    notificationable_type.constantize.find(notificationable_id)
  end

  def unread?
    !read
  end

  def read?
    read == true
  end

  def object_class_name
    object.class.name
  end

  def mark_as_read
    update_attribute(:read, true)
  end
end
