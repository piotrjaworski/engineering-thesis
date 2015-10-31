class Message < ActiveRecord::Base
  belongs_to :addressee, class_name: "User", foreign_key: "addressee_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :message_thread, touch: true

  def users
    User.find([addressee_id, sender_id])
  end

  def exclude_user(user)
    user_id = user.id == message_thread.addressee_id ? message_thread.sender_id : message_thread.addressee_id
    User.find(user_id)
  end

end
