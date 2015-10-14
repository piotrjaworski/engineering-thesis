class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :edit, Post, user_id: user.id
    can :update, Post, user_id: user.id

  end
end
