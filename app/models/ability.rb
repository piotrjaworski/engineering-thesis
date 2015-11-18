class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.user?
      user_abilities(user)
    elsif user.moderator?
      moderator_abilities(user)
    elsif user.admin?
      admin_abilities(user)
    end
  end

  def admin_abilities(user)
    can :edit, Post
    can :update, Post
    can :show, MessageThread, addressee_id: user.id
    can :show, MessageThread, sender_id: user.id
    can :reply, MessageThread, addressee_id: user.id
    can :reply, MessageThread, sender_id: user.id
    can :close, Topic
    can :open, Topic
  end

  def moderator_abilities(user)
    can :edit, Post
    can :update, Post
    can :show, MessageThread, addressee_id: user.id
    can :show, MessageThread, sender_id: user.id
    can :reply, MessageThread, addressee_id: user.id
    can :reply, MessageThread, sender_id: user.id
    can :close, Topic
    can :open, Topic
  end

  def user_abilities(user)
    can :edit, Post, user_id: user.id
    can :update, Post, user_id: user.id
    can :show, MessageThread, addressee_id: user.id
    can :show, MessageThread, sender_id: user.id
    can :reply, MessageThread, addressee_id: user.id
    can :reply, MessageThread, sender_id: user.id
  end
end
