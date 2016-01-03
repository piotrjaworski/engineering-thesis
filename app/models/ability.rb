class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.user?
      user_abilities(user)
    elsif user.moderator? || user.admin?
      superuser_abilities(user)
    end
  end

  def superuser_abilities(user)
    can :manage, Topic
    can :manage, Post
    can :show, MessageThread, addressee_id: user.id
    can :show, MessageThread, sender_id: user.id
    can :reply, MessageThread, addressee_id: user.id
    can :reply, MessageThread, sender_id: user.id
  end

  def user_abilities(user)
    can :edit, Topic, creator_id: user.id
    can :destroy, Topic, creator_id: user.id
    can :edit, Post, user_id: user.id
    can :update, Post, user_id: user.id
    can :destroy, Post do |post|
      post.user == user && post.last?
    end
    can :show, MessageThread, addressee_id: user.id
    can :show, MessageThread, sender_id: user.id
    can :reply, MessageThread, addressee_id: user.id
    can :reply, MessageThread, sender_id: user.id
  end
end
