class NotificationsWorker
  include Sidekiq::Worker

  def perform(user_id, action, object = {})
    name = if object["class"] == "Message"
             "sent a new message"
           elsif object["class"] == "Post"
             "added a new post"
           else
             nil
           end
    Notification.create(notificationable_type: object["class"], notificationable_id: object["id"], user_id: user_id, name: name)
  end
end
