class AvatarsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user.get_avatar
  end

end
