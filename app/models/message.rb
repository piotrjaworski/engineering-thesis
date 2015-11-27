class Message < ActiveRecord::Base
  belongs_to :addressee, class_name: "User", foreign_key: "addressee_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :message_thread, touch: true
  has_one :notification, as: :notificationable

  after_create :send_notification, unless: :skip_callbacks

  def users
    User.find([addressee_id, sender_id])
  end

  def exclude_user(user)
    user_id = user.id == message_thread.addressee_id ? message_thread.sender_id : message_thread.addressee_id
    User.find(user_id)
  end

  def mark_as_read
    return false if !unread
    update_column(:unread, false)
  end

  private

  def send_notification
    NotificationsWorker.perform_async(addressee.id, class: "Message", id: id) if addressee.want_message_notifications?
  end

  def skip_callbacks
    Rails.env == "test"
  end
end
