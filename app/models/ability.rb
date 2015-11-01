class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.is_user?
      can :edit, Post, user_id: user.id
      can :update, Post, user_id: user.id
      can :show, MessageThread, addressee_id: user.id
      can :show, MessageThread, sender_id: user.id
      can :reply, MessageThread, addressee_id: user.id
      can :reply, MessageThread, sender_id: user.id
    elsif user.is_moderator?
      can :edit, Post
      can :update, Post
      can :show, MessageThread, addressee_id: user.id
      can :show, MessageThread, sender_id: user.id
      can :reply, MessageThread, addressee_id: user.id
      can :reply, MessageThread, sender_id: user.id
      can :close, Topic
      can :open, Topic
    elsif user.is_admin?
      can :edit, Post
      can :update, Post
      can :show, MessageThread, addressee_id: user.id
      can :show, MessageThread, sender_id: user.id
      can :reply, MessageThread, addressee_id: user.id
      can :reply, MessageThread, sender_id: user.id
      can :close, Topic
      can :open, Topic
    end
  end
end
