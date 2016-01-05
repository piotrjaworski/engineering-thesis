module NotificationsHelper
  def notifiaction_link(notification)
    if notification.notificationable_type == 'Message'
      message_thread = Message.find(notification.notificationable_id).message_thread
      user_message_thread_path(user_id: current_user.id, id: message_thread.id)
    end
  end
end
