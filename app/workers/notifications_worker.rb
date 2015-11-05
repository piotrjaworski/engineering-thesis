class NotificationsWorker
  include Sidekiq::Worker

  def perform(user_id, action, object = {})
    user = User.find(user_id)
    name = if object[:class] == "Message"
      "send a new message"
    else
      nil
    end
    notification = Notification.create(notificationable_type: object[:class], notificationable_id: object[:id], user_id: user_id, name: name)
  end
end
