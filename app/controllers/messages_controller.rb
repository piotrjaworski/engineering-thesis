class MessagesController < ApplicationController

  def index
  end

  def new
    @addressee = User.friendly.find(params[:user_id])
    @message_thread = current_user.message_threads_sent.new(addressee_id: @addressee.id)
    @message_thread.messages.build
  end

  def create
  end

end
